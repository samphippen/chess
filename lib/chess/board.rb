module Chess
  class Board
    RANK_COUNT = 8
    FILE_COUNT = 8

    def self.from_fen(fen)
      fen_input = FenInput.new(fen)
      new(fen_input.squares, fen_input.player_to_move)
    end

    def self.default
      new([
        %w{r n b q k b n r},
        %w{p p p p p p p p},
        [nil] * 8,
        [nil] * 8,
        [nil] * 8,
        [nil] * 8,
        %w{P P P P P P P P},
        %w{R N B Q K B N R}
      ], :white)
    end

    attr_reader :player_to_move

    def initialize(squares, player_to_move)
      @squares = squares
      @player_to_move = player_to_move
      validate_position
    end

    def to_s
      @squares.map {|rank| rank.map {|file| file.nil? ? "." : file }.join }.join("\n")
    end

    def move(from, to, promotion_piece = nil)
      piece = get_piece_at(from)
      set_piece_at(from, nil)
      set_piece_at(to, promotion_piece || piece)
      change_player
    end

    private
    def validate_position
      if @squares.size != RANK_COUNT
        raise ArgumentError, "Board must have 8 ranks"
      elsif @squares.any? {|file| file.size != FILE_COUNT }
        raise ArgumentError, "Each rank must have 8 files"
      end
    end

    def get_piece_at(square)
      rank, file = coordinates_of(square)
      @squares[rank][file]
    end

    def set_piece_at(square, piece)
      rank, file = coordinates_of(square)
      @squares[rank][file] = piece
    end

    def coordinates_of(square)
      [8 - square[1,1].to_i, square[0].ord - ?a.ord]
    end

    def change_player
      @player_to_move = @player_to_move == :white ? :black : :white
    end
  end
end
