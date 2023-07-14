# frozen_string_literal: true

require_relative "tic_tac_toe/version"

module TicTacToe
  # TODO: top-level documenation comment
  class Board
    attr_reader :size, :board

    def initialize
      @size = 3
      reset
    end

    def legal?(pos)
      pos && !board[pos - 1] && pos.between?(1, size**2)
    end

    def place_symbol(pos, symbol)
      board[pos - 1] = symbol if legal?(pos)
    end

    def row(row_idx)
      board.values_at(*(size * row_idx).upto(size * (row_idx + 1) - 1))
    end

    def column(column_idx)
      board.values_at(*column_idx.step(by: size, to: size**2 - 1))
    end

    def first_diagonal
      board.values_at(*0.step(by: size + 1, to: size**2 - 1))
    end

    def second_diagonal
      board.values_at(*(size - 1).step(by: size - 1, to: size * (size - 1)))
    end

    def win?(symbol)
      lines = [first_diagonal, second_diagonal]
      0.upto(size - 1) do |idx|
        lines.push(row(idx))
        lines.push(column(idx))
      end
      lines.any? { |line| line.all?(&symbol.method(:==)) }
    end

    def reset
      @board = Array.new(size**2)
    end

    def to_s
      padding = "".ljust(4)
      line_separator = "#{padding}#{(["---"] * 3).join("+")}\n"
      board_string = 0.upto(size - 1).map { |row_idx| "#{padding}#{format_row(row_idx)}" }.join(line_separator)
      "\n#{board_string}\n"
    end

    private

    def format_row(row_idx)
      formatted_content = row(row_idx).map.with_index do |symbol, col_idx|
        (symbol || 3 * row_idx + col_idx + 1).to_s.center(3)
      end.join("|")
      "#{formatted_content}\n"
    end
  end

  # TODO: top-level documenation comment
  class Player
    attr_reader :name, :symbol

    def initialize(name, symbol)
      @name = name
      @symbol = symbol
    end
  end

  # TODO: top-level documenation comment
  class GameState
    attr_reader :board, :turn, :players

    def initialize(players)
      @board = TicTacToe::Board.new
      @turn = 0
      @players = players
    end

    def game_over?
      turn == board.size**2 || players.map(&:symbol).any? { |symbol| board.win?(symbol) }
    end

    def current_player
      players[turn % 2]
    end

    def make_move(pos)
      board.place_symbol(pos, current_player.symbol)
      @turn += 1
    end

    def winner
      players.find { |player| board.win?(player.symbol) }
    end

    def legal_move?(move)
      board.legal?(move)
    end

    def reset
      board.reset
      @turn = 0
    end
  end

  # TODO: top-level documenation comment
  class Game
    attr_reader :players, :game_state

    def initialize
      @players = 2.times.map { |player_number| create_player(player_number + 1) }
      @game_state = GameState.new(players)
    end

    def play
      game_state.reset
      play_turn until game_state.game_over?

      system "clear" or system "cls"
      puts
      puts game_state.board
      winner = game_state.winner
      puts "#{winner ? "#{winner.name} won!" : "It's a draw!"}, Play again? [Y/n]"

      answer = gets.chomp.downcase until ["y", "n", ""].include?(answer)
      play unless answer == "n"
    end

    private

    def prompt_move(header = "\n")
      puts header
      puts game_state.board
      puts "#{game_state.current_player.name}, make a move (1 - 9)"
      gets.chomp.to_i
    end

    def play_turn
      system "clear" or system "cls"
      move = prompt_move
      until game_state.legal_move?(move)
        system "clear" or system "cls"
        move = prompt_move("This move is illegal.")
      end

      game_state.make_move(move)
    end

    def create_player(player_number)
      system "clear" or system "cls"

      puts "Player #{player_number}, what's you name?"
      name = gets.chomp.capitalize

      default_symbol = player_number == 1 ? :X : :O
      puts "Choose your token: (press enter for default: #{default_symbol})"
      answer = gets.chomp
      symbol = answer == "" ? default_symbol : answer

      Player.new(name, symbol)
    end
  end
end

def main
  game = TicTacToe::Game.new
  game.play
end

main
