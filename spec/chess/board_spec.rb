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

    it "raises an error if the board has less than 8 ranks" do
      expect { Chess::Board.new([[nil] * 8] * 7) }.to raise_error(ArgumentError)
    end

    it "raises an error if the board has more than 8 ranks" do
      expect { Chess::Board.new([[nil] * 8] * 9) }.to raise_error(ArgumentError)
    end

    it "raises an error if the board has a rank with more than 8 files" do
      8.times do |i|
        squares = [[nil] * 8] * 8
        squares[i] << nil
        expect { Chess::Board.new(squares) }.to raise_error(ArgumentError)
      end
    end

    it "raises an error if the board has a rank with more than 8 files" do
      8.times do |i|
        squares = [[nil] * 8] * 8
        squares[i].pop
        expect { Chess::Board.new(squares) }.to raise_error(ArgumentError)
      end
    end
  end
end
