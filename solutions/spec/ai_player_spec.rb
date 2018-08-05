require 'byebug'
require 'ai_player.rb'

describe AIPlayer do
  let(:some_cards) do
    some_cards = [
      Card.new(:hearts, :queen),
      Card.new(:clubs, :three),
      Card.new(:spades, :ace),
      Card.new(:spades, :queen),
      Card.new(:clubs, :jack)
    ]
  end

  let(:some_cards_1000) do
    some_cards_1000 = [
    Card.new(:hearts, :queen),
    Card.new(:clubs, :three),
    Card.new(:spades, :ace),
    Card.new(:spades, :king),
    Card.new(:clubs, :jack)
  ]
  end

  let(:some_game) {double 'some_game'}
  let(:some_deck) {Deck.all_cards}
  subject(:hal) {AIPlayer.new(some_cards)}

  before(:each) do
    allow(some_game).to receive(:register_book)
  end

  describe ':#initialize' do
    it "creates an instance of AIPlayer class" do
      expect(hal).to be_a(AIPlayer)
    end

    it "creates a player with a given hand (array of cards)" do
      hal1000 = AIPlayer.new(some_cards)
      expect(hal1000.hand.first).to be(some_cards.first)
    end
  end

  describe '::go_fish_init' do
    subject(:hal) {AIPlayer.go_fish_init(some_deck)}

    it "returns an instance of class AIPlayer" do
      expect(hal).to be_a(AIPlayer)
    end

    it "returns an AIPlayer with a hand of 5 cards" do
      expect(hal.hand.count).to be(5)
    end

    it "calls the deck's #take method" do
      expect(some_deck).to receive(:take)
      AIPlayer.go_fish_init(some_deck)
    end
  end

  describe '#most_common_card' do
    it "returns a valid card value" do
      expect(Card.values).to include(hal.most_common_card)
    end

    it "returns a card value most represented in hand" do
      expect(hal.most_common_card).to eq(:queen)
    end

    it "returns any value if no card is most common" do
      expect(Card.values).to include(AIPlayer.new(some_cards_1000).most_common_card)
    end
  end

  describe '#request_card' do
    let(:alpha_hal) {double 'alpha_hal'}
    card = Card.new(:clubs, :queen)

    before(:each) do
      expect(alpha_hal).to receive(:demand).with(:queen, some_deck).and_return([card])
      hal.opponents << alpha_hal
    end

    it "requests the most common card form a random opponent" do
      hal.request_card(some_deck)
    end

    it "adds cads given up by other player to own hand" do
      hal.request_card(some_deck)
      expect(hal.hand).to include(card)
    end
  end

  describe '#demand' do
    it "returns and array of all cards of demanded value if they are in hand" do
      expect(hal.demand(:queen, some_deck)).to eq([some_cards[0], some_cards[3]])
    end

    it "deletes the demanded cards from the hand" do
      hal.demand(:queen, some_deck)
      expect(hal.hand.any?{|card| card.value == :queen}).to be false
    end

    it "draws a new hand of 5 cards if the incoming dmand depleted the hand" do
      hal4000 = AIPlayer.new([Card.new(:hearts, :queen)])
      hal4000.demand(:queen, some_deck)
      expect(hal4000.hand.count).to be 5
    end

    it "raises an exception 'Go Fish!' if the card is not in hand" do
      expect {hal.demand(:king, some_deck)}.to raise_error('Go Fish!')
    end
  end

  describe '#go_fishing' do
    it "draws a card from the deck (places back of hand)" do
      first_card = some_deck.first
      hal.go_fishing(some_deck)
      expect(hal.hand.last).to be(first_card)
    end

    it "returns nil if the deck is empty" do
      deck = Deck.new([])
      expect(hal.go_fishing(deck)).to eq(nil)
    end
  end

  describe '#discard_books' do
    before(:each) do
      hal.hand << Card.new(:diamonds, :queen)
      hal.hand << Card.new(:clubs, :queen)
      hal.discard_books(some_game)
    end

    it "adds a point to the score for each book (4-card combo) discarded" do
      expect(hal.score).to be 1
    end

    it "removes books from players hand" do
      expect(hal.hand.any?{|card| card.value == :queen}).to be false
    end

    it "registers books with the game by calling game#register_book" do
      hal.hand << Card.new(:diamonds, :queen)
      hal.hand << Card.new(:diamonds, :queen)
      hal.hand << Card.new(:diamonds, :queen)
      hal.hand << Card.new(:clubs, :queen)
      expect(some_game).to receive(:register_book)
      hal.discard_books(some_game)
    end
  end

  describe '#take_turn' do
    let(:alpha_hal) {double 'alpha_hal'}


    it "requests a card from a player" do
      expect(hal).to receive(:request_card)
      hal.take_turn(some_game, some_deck )
    end

    it "goes fishing when the opponent returns a 'Go Fish!' error" do
      allow(alpha_hal).to receive(:demand).and_raise('Go Fish!')
      expect(hal).to receive(:go_fishing)
      hal.opponents << alpha_hal
      hal.take_turn(some_game, some_deck)
    end

    let(:alpha_hal) {double 'alpha_hal'}
    let(:fake_deck) {double 'fake_deck'}

    it "discard books at the end of each turn" do
      card1 = Card.new(:clubs, :queen)
      card2 = Card.new(:diamonds, :queen)
      allow(alpha_hal).to receive(:demand).and_return([card1, card2])
      hal.opponents << alpha_hal

      expect(hal).to receive(:discard_books)
      hal.take_turn(some_game, some_deck)
    end

    it "discards books even if has gone fishing" do
      allow(alpha_hal).to receive(:demand).and_raise('Go Fish!')
      hal.opponents << alpha_hal
      expect(hal).to receive(:discard_books)
      hal.take_turn(some_game, some_deck)
    end

    it "draws 5 more cards at the end of the turn if hand is empty" do
      fake_deck = Deck.new([Card.new(:spades, :queen),Card.new(:spades, :queen),Card.new(:spades, :queen),Card.new(:spades, :queen),Card.new(:spades, :queen),Card.new(:spades, :queen)])
      hal3000 = AIPlayer.new([Card.new(:spades, :queen),Card.new(:spades, :queen),Card.new(:spades, :queen)])
      hal3000.take_turn(some_game, fake_deck)
      expect(hal3000.hand.count).to be 5
    end
  end
end
