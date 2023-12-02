require "./lib/connect_four.rb"

describe 'ConnectFour' do
  let(:game) { Game.new }
  let(:board) { game.instance_variable_get(:@board) }

  describe 'Game' do
    it 'initializes with a new board and two players' do
      expect(game.instance_variable_get(:@current_player).symbol).to eq('X')
      expect(game.instance_variable_get(:@other_player).symbol).to eq('O')
      expect(board.board.all? { |row| row.all? { |cell| cell.value == "" } }).to be true
    end
  end

  describe 'Board' do
    it 'adds a piece to the board' do
      board.add_piece(0, 'X')
      expect(board.board[5][0].value).to eq('X')
    end

    it 'does not add a piece to a full column' do
      6.times { board.add_piece(0, 'X') }
      expect(board.add_piece(0, 'X')).to be false
    end

    it 'detects a winning combination in a column' do
      4.times { board.add_piece(0, 'X') }
      expect(board.winning_combination?('X')).to be true
    end

    it 'detects a winning combination in a row' do
      (0..3).each { |i| board.add_piece(i, 'X') }
      expect(board.winning_combination?('X')).to be true
    end

    it 'detects a winning combination in a diagonal' do
      (0..3).each do |i|
        (i+1).times { board.add_piece(i, 'O') }
        board.add_piece(i, 'X')
      end
      expect(board.winning_combination?('X')).to be true
    end

    it 'does not detect a winning combination if there is none' do
      (0..2).each { |i| board.add_piece(i, 'X') }
      expect(board.winning_combination?('X')).to be false
    end
  end

  describe 'Player' do
    let(:player) { Player.new('X') }

    it 'initializes with a symbol' do
      expect(player.symbol).to eq('X')
    end
  end
end
