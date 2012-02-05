require 'spec_helper'

describe Chess::Board do
  context "in its initial state" do
    it "has the pieces in the default setup" do
      subject.should match_position <<-EOF
        rnbqkbnr
        pppppppp
        ........
        ........
        ........
        ........
        PPPPPPPP
        RNBQKBNR
      EOF
    end
  end

  context ".from_fen" do
    it "creates a board with the pieces in the positions specified" do
      board = Chess::Board.from_fen("rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2")
      board.should match_position <<-EOF
        rnbqkbnr
        pp.ppppp
        ........
        ..p.....
        ....P...
        ........
        PPPP.PPP
        RNBQKBNR
      EOF
    end
  end

  describe "#initialize" do
    it "takes a position as an array" do
      board = Chess::Board.new([
        ["K", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, "k", nil, nil, nil, nil, nil]
      ])
      board.should match_position <<-EOF
        K.......
        ........
        ........
        ........
        ........
        ........
        ........
        ..k.....
      EOF
    end

    it "takes whose turn it is" do
      board = Chess::Board.new([
        ["K", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, "k", nil, nil, nil, nil, nil]
      ], :black)
      board.player_to_move.should == :black
    end

    it "defaults the player's turn to white" do
      Chess::Board.new.player_to_move.should == :white
    end

    let(:default_squares) { [[nil] * Chess::Board::FILE_COUNT] * Chess::Board::RANK_COUNT }

    it "raises an error if the board has less than 8 ranks" do
      expect { Chess::Board.new(default_squares.tap(&:pop)) }.to raise_error(ArgumentError)
    end

    it "raises an error if the board has more than 8 ranks" do
      expect { Chess::Board.new(default_squares.tap {|s| s << ([nil] * 8)}) }.to raise_error(ArgumentError)
    end

    it "raises an error if the board has a rank with more than 8 files" do
      Chess::Board::RANK_COUNT.times do |i|
        squares = default_squares
        squares[i] << nil
        expect { Chess::Board.new(squares) }.to raise_error(ArgumentError)
      end
    end

    it "raises an error if the board has a rank with more than 8 files" do
      Chess::Board::RANK_COUNT.times do |i|
        squares = default_squares
        squares[i].pop
        expect { Chess::Board.new(squares) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#move" do
    let(:board) do
      Chess::Board.new([
        ["K", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, "k", nil, nil, nil, nil, nil]
      ])
    end

    it "moves the piece from the square it's on to the new square" do
      board.move("a8", "a7")
      board.should match_position <<-EOF
        ........
        K.......
        ........
        ........
        ........
        ........
        ........
        ..k.....
      EOF
    end

    it "makes it the other player's turn" do
      board.move("a8", "a7")
      board.player_to_move.should == :black
      board.move("c1", "c2")
      board.player_to_move.should == :white
    end
  end
end
