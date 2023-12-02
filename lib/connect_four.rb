class Cell
  attr_accessor :value
  def initialize(value = "")
    @value = value
  end
end

class Board
  attr_reader :board
  def initialize
    @board = Array.new(6) { Array.new(7) { Cell.new } }
  end

  def display
    @board.each do |row|
      puts row.map { |cell| cell.value.empty? ? '.' : cell.value }.join(' ')
    end
    puts '0 1 2 3 4 5 6'
  end

  def add_piece(col, piece)
    5.downto(0) do |row|
      if @board[row][col].value == ""
        @board[row][col].value = piece
        return true
      end
    end
    false
  end

  def winning_combination?(piece)
    horizontal?(piece) || vertical?(piece) || diagonal?(piece)
  end

  def full?
    @board.all? { |row| row.all? { |cell| !cell.value.empty? } }
  end

  private

  def horizontal?(piece)
    @board.any? { |row| row.each_cons(4).any? { |four| four.all? { |cell| cell.value == piece } } }
  end

  def vertical?(piece)
    @board.transpose.any? { |row| row.each_cons(4).any? { |four| four.all? { |cell| cell.value == piece } } }
  end

  def diagonal?(piece)
    diagonals.any? { |row| row.each_cons(4).any? { |four| four.all? { |cell| cell.value == piece } } }
  end

  def diagonals
    return [
      [@board[3][0], @board[2][1], @board[1][2], @board[0][3]],
      [@board[4][0], @board[3][1], @board[2][2], @board[1][3], @board[0][4]],
      [@board[5][0], @board[4][1], @board[3][2], @board[2][3], @board[1][4], @board[0][5]],
      [@board[5][1], @board[4][2], @board[3][3], @board[2][4], @board[1][5], @board[0][6]],
      [@board[5][2], @board[4][3], @board[3][4], @board[2][5], @board[1][6]],
      [@board[5][3], @board[4][4], @board[3][5], @board[2][6]],
      [@board[5][4], @board[4][5], @board[3][6]],
      [@board[5][5], @board[4][6]],
      [@board[5][6]],
      [@board[5][5], @board[4][4], @board[3][3], @board[2][2], @board[1][1], @board[0][0]],
      [@board[5][6], @board[4][5], @board[3][4], @board[2][3], @board[1][2], @board[0][1]],
      [@board[4][6], @board[3][5], @board[2][4], @board[1][3], @board[0][2]],
      [@board[3][6], @board[2][5], @board[1][4], @board[0][3]],
      [@board[2][6], @board[1][5], @board[0][4]],
      [@board[1][6], @board[0][5]],
      [@board[0][6]]
    ]
  end
end

class Player
  attr_reader :symbol
  def initialize(symbol)
    @symbol = symbol
  end
end

class Game
  def initialize
    @board = Board.new
    @current_player = Player.new('X')
    @other_player = Player.new('O')
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def ask_for_column
    loop do
      puts "Enter a column number (0-6):"
      input = gets.chomp
      if input.match?(/^\d+$/) && (0..6).include?(input.to_i)
        return input.to_i
      else
        puts "Invalid column number. Please enter a number between 0 and 6."
      end
    end
  end

  def display_current_player
    if @current_player.symbol == 'X'
      puts "Player 1:"
    else
      puts "Player 2:"
    end
  end

  def play
    loop do
      display_current_player
      @board.display
      column = ask_for_column
      until @board.add_piece(column, @current_player.symbol)
        puts "Column full! Try a different one:"
        column = ask_for_column
      end
      @board.display
      if @board.winning_combination?(@current_player.symbol)
        if board.full?
          puts "It's a tie!"
        elsif @current_player.symbol == 'X'
          puts "Player 1 wins!"
        else
          puts "Player 2 wins!"
        end
        return
      end
      switch_players
    end
  end
end

game = Game.new
game.play
