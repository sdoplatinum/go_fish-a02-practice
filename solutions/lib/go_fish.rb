require 'ai_player'
require 'byebug'

class GoFish
  attr_reader :deck, :players, :current_player_idx
  attr_accessor :books_complete

  def initialize(players)
    @deck = Deck.new
    @players = players
    @current_player_idx = 0
    @books_complete = 0

    players.each do |player|
      players.each do |opponent|
        player.opponents << opponent unless opponent == player
      end
    end
  end

  def game_over?
    books_complete == 13
  end

  def register_book
    self.books_complete += 1
  end

  def switch_players
    self.current_player_idx = (current_player_idx + 1) % players.length
  end

  def current_player
    players[current_player_idx]
  end

  private

  attr_writer :current_player_idx
end
