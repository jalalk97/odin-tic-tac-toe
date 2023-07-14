# frozen_string_literal: true

RSpec.describe TicTacToe do
  it "has a version number" do
    expect(TicTacToe::VERSION).not_to be nil
  end

  context "place_symbol" do
    let(:board) { TicTacToe::Board.new }

    it "updates the board correctly when the given position is valid and vacant" do
      board.place_symbol(5, :x)
      expect(board.board).to eq([nil, nil, nil, nil, :x, nil, nil, nil, nil])
    end

    describe "leaves the board unchanged" do
      let(:expected_output) { [nil, nil, nil, nil, nil, nil, nil, nil, nil] }

      it "when the given position is negative" do
        board.place_symbol(-1, :x)
        expect(board.board).to eq(expected_output)
      end

      it "when the given position is zero" do
        board.place_symbol(0, :x)
        expect(board.board).to eq(expected_output)
      end

      it "when the given position is out of bounds" do
        board.place_symbol(10, :x)
        expect(board.board).to eq(expected_output)
      end

      before(:example) do
        board.place_symbol(5, :x)
        expected_output[4] = :x
      end

      it "when the given position is occupied" do
        board.place_symbol(5, :y)
        expect(board.board).to eq(expected_output)
      end
    end
  end

  context "row" do
    let(:board) { TicTacToe::Board.new }

    before(:each) do
      1.upto(9).each { |i| board.place_symbol(i, i) }
    end

    it "returns the first row" do
      expect(board.send(:row, 0)).to eq([1, 2, 3])
    end

    it "returns the second row" do
      expect(board.send(:row, 1)).to eq([4, 5, 6])
    end

    it "returns the third row" do
      expect(board.send(:row, 2)).to eq([7, 8, 9])
    end
  end

  context "column" do
    let(:board) { TicTacToe::Board.new }

    before(:each) do
      1.upto(9).each { |i| board.place_symbol(i, i) }
    end

    it "returns the first column" do
      expect(board.send(:column, 0)).to eq([1, 4, 7])
    end

    it "returns the second column" do
      expect(board.send(:column, 1)).to eq([2, 5, 8])
    end

    it "returns the third column" do
      expect(board.send(:column, 2)).to eq([3, 6, 9])
    end
  end

  context "first_diagonal" do
    it "works correctly" do
      board = TicTacToe::Board.new
      1.upto(9).each { |i| board.place_symbol(i, i) }

      expect(board.send(:first_diagonal)).to eq([1, 5, 9])
    end
  end

  context "second_diagonal" do
    it "works correctly" do
      board = TicTacToe::Board.new
      1.upto(9).each { |i| board.place_symbol(i, i) }

      expect(board.send(:second_diagonal)).to eq([3, 5, 7])
    end
  end

  context "win?" do
    let(:board) { TicTacToe::Board.new }

    describe "detects a win " do
      it "when it's on a row" do
        1.upto(3) { |i| board.place_symbol(i, :x) }
        expect(board.win?(:x)).to be true
      end

      it "when it's on a column" do
        1.step(by: 3, to: 7) { |i| board.place_symbol(i, :x) }
        expect(board.win?(:x)).to be true
      end

      it "when it's on the first diagonal" do
        1.step(by: 4, to: 9) { |i| board.place_symbol(i, :x) }
        expect(board.win?(:x)).to be true
      end

      it "when it's on the second diagonal" do
        3.step(by: 2, to: 7) { |i| board.place_symbol(i, :x) }
        expect(board.win?(:x)).to be true
      end
    end

    describe "correctly identifies that there is no win" do
      it "when the board is empty" do
        expect(board.win?(:x)).to be false
      end

      it "when there are symbols on the board" do
        board.place_symbol(1, :x)
        board.place_symbol(9, :x)
        expect(board.win?(:x)).to be false
      end
    end
  end

  context "reset" do
    it "replaces every entry with nil" do
      board = TicTacToe::Board.new
      1.upto(9).each { |i| board.place_symbol(i, :x) }

      board.reset

      expect(board.board.all?(&nil.method(:==))).to be true
      expect(board.board.length).to eql(9)
    end
  end
end
