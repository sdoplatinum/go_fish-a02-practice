require 'go_fish'

describe GoFish do
    let(:pl1) {AIPlayer.new([Card.new(:clubs, :deuce)])}
    let(:pl2) {AIPlayer.new([Card.new(:clubs, :three)])}
    let(:pl3) {AIPlayer.new(Deck.all_cards)}
    subject(:game) {GoFish.new([pl1, pl2, pl3])}

  describe '#initialize' do
    it "creates an isntance of the GoFish class" do
      expect(game).to be_a(GoFish)
    end

    it "defaults to a standard 52 card deck" do
      expect(game.deck).to be_a(Deck)
      expect(game.deck.count).to be 52
    end

    it "accepts an array of players and sets them to the players variable" do
      expect(game.players).to include(pl1)
      expect(game.players).to include(pl2)
    end

    it "sends a list of their opponents to each player" do
      pl1 = AIPlayer.new()
      pl2 = AIPlayer.new()
      game = GoFish.new([pl1, pl2])
      expect(pl1.opponents).to include(pl2)
      expect(pl2.opponents).to include(pl1)
    end

    it "does not include the player in his own list of opponents" do
      pl1 = AIPlayer.new()
      pl2 = AIPlayer.new()
      game = GoFish.new([pl1, pl2])
      expect(pl1.opponents).not_to include(pl1)
      expect(pl2.opponents).not_to include(pl2)
    end
  end

  describe '#register_book' do
    it "increments the numebr of books as they are registered by players" do
      pl3.discard_books(game)
      expect(game.books_complete).to be 13
    end
  end

  describe '#game_over?' do
    it "determines that the game is over if the players have accumilated 13 points" do
      pl3.discard_books(game)
      expect(game.game_over?).to be true
    end
  end

  describe '#current_player' do
    it "returns the current active player from the players array" do
      expect(game.current_player).to be(pl1)
    end
  end

  describe '#switch_players' do
    it "cycles to the next player" do
      game.switch_players
      expect(game.current_player).to be(pl2)
    end

    it "handles more than 2 players" do
      game.switch_players
      game.switch_players
      expect(game.current_player).to be(pl3)
    end
  end

  describe '#play_game !!!MAY CAUSE INFINITE LOOP!!!' do
    pl1 = AIPlayer.new([Card.new(:clubs, :deuce)])
    pl2 = AIPlayer.new([Card.new(:clubs, :three)])
    pl3 = AIPlayer.new(Deck.all_cards.drop(2))
    game = GoFish.new([pl1, pl2, pl3])

    it "should call #take_turn on players until the game is over" do
      expect(pl1).to receive(:take_turn).at_least(:once)
      game.play_game
      expect(game.books_complete).to be 13
    end

    pl1 = AIPlayer.new([Card.new(:clubs, :deuce)])
    pl2 = AIPlayer.new([Card.new(:clubs, :three)])
    pl3 = AIPlayer.new(Deck.all_cards.drop(2))
    game = GoFish.new([pl1, pl2, pl3])

    it "returns the winning player" do
      expect(game.play_game).to be(pl3)
    end
  end
end
