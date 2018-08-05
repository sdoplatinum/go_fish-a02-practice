require 'deck'

class AIPlayer

  attr_reader :hand, :opponents, :score

  def self.go_fish_init(deck)

  end

  def initialize(hand = nil)

  end

  #Returns the most common card value in hand.
  def most_common_card

  end

  #Demands the most common card from a randomly selected opponent.
  def request_card(deck)

  end

  #Handles and incoming demand for a card with the value passed.
  def demand(value, deck)

  end

  #Draws a card from the deck when told to go fish.
  def go_fishing(deck)

  end

  def discard_books(game)

  end

  #Takes a turn.
  def take_turn(game, deck)

  end

  private

  attr_writer :score, :hand
end
