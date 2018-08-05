require 'ai_player'
require 'byebug'

class GoFish
  attr_reader :deck, :players, :current_player_idx
  attr_accessor :books_complete

  def initialize(players)
    @deck = nil
    @players = nil
    @current_player_idx = nil
    @books_complete = 0
  end

  def game_over?

  end

  def register_book

  end

  def switch_players

  end

  def current_player

  end

  private

  attr_writer :current_player_idx
end
