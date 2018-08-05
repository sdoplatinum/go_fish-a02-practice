require 'deck'
require 'byebug'

class AIPlayer

  attr_reader :hand, :opponents, :score

  def self.go_fish_init(deck)
    AIPlayer.new(deck.take(5))
  end

  def initialize(hand = nil)
    @hand = hand
    @opponents = []
    @score = 0
  end

  #Returns the most common card value in hand.
  def most_common_card
    card_count = Hash.new(0)

    hand.each { |card| card_count[card.value] += 1}
    card_count.to_a.sort_by {|card| card[1]}.last.first
  end

  #Demands the most common card from a randomly selected opponent.
  def request_card(deck)
    cards_given = opponents.sample.demand(most_common_card, deck)
    hand.concat(cards_given)
  end

  #Handles and incoming demand for a card with the value passed.
  def demand(value, deck)
    demanded_cards = hand.select{ |card| card.value == value }

    unless demanded_cards.empty?
      self.hand -= demanded_cards
      self.hand = deck.take(5) if hand.empty?
      return demanded_cards
    end

    raise "Go Fish!"
  end

  #Draws a card from the deck when told to go fish.
  def go_fishing(deck)
    hand.concat(deck.take(1)) unless deck.empty?
  end

  def discard_books(game)
    card_count = Hash.new(0)

    hand.each { |card| card_count[card.value] += 1 }

    books = card_count.select { |_, count| count == 4 }
    books.each do |value, _|
      self.score += 1
      game.register_book
      hand.delete_if { |card| card.value == value }
    end
  end

  #Takes a turn.
  def take_turn(game, deck)
    request_card(deck)
    rescue
      go_fishing(deck)
    ensure
      discard_books(game)
      self.hand = deck.take(5) if hand.empty?
  end

  private

  attr_writer :score, :hand
end
