require 'tetris'

describe Tetris, "#initialization" do
  it "creates a grid of the right size" do
    tetris = Tetris.new
    tetris.width.should eq(DEFAULT_WIDTH)
    tetris.height.should eq(DEFAULT_HEIGHT)
  end

  it "creates an empty grid of the right size" do
    tetris = Tetris.new
    grid = tetris.grid
    grid.each do |row| 
      row.each do |item| 
        #item.should be_false -- TO ASK DAVE, why is this true for nil values
        item.should eq(false)
      end
    end
  end
end



# default shape to use.  A shape is just a 2d grid of booleans (width,height)
SQUARE = [[true, true], [true, true]]


describe Tetris, "#current_piece_mechanics" do
  it "places the current piece at the top at a given xy position when it is created" do
    piece = Tetris::Piece.new(SQUARE)
    tetris = Tetris.new
    tetris.place_piece(5, piece)
    tetris.current_piece_position[0].should eq(5)
    tetris.current_piece_position[1].should eq(DEFAULT_HEIGHT - 2)
  end
  it "cannot place the piece at a negative x" do
    piece = Tetris::Piece.new(SQUARE)
    tetris = Tetris.new
    expect { tetris.place_piece(-2, piece) }.to raise_error(RangeError)
  end
  it "cannot place the piece at a x that is bigger or equal to the width of tetris" do
    piece = Tetris::Piece.new(SQUARE)
    tetris = Tetris.new
    expect { tetris.place_piece(DEFAULT_WIDTH, piece) }.to raise_error(RangeError)
  end
  it "fills the at the initial location with the grid of the piece" do
    piece = Tetris::Piece.new(SQUARE)
    tetris = Tetris.new
    tetris.place_piece(5, piece)
    grid = tetris.grid
    width = tetris.width
    height = tetris.height
    0.upto(SQUARE.length-1) {|i| 0.upto(SQUARE[0].length - 1) {|j| grid[5+i][j + height - 2].should eq(SQUARE[i][j]) }}
  end
  it "a piece can't be shifted past the left boundary" do
    piece = Tetris::Piece.new(SQUARE)
    tetris = Tetris.new
    tetris.place_piece(0, piece)
    expect { tetris.shift_current_piece(-1) }.to raise_error(RangeError)
  end

  it "a piece can't be shifted past the right boundary" do
    piece = Tetris::Piece.new(SQUARE)
    tetris = Tetris.new
    tetris.place_piece(DEFAULT_WIDTH - SQUARE[0].length, piece)
    expect { tetris.shift_current_piece(1) }.to raise_error(RangeError)
  end

  it "the current piece can shift left" do
    piece = Tetris::Piece.new(SQUARE)
    tetris = Tetris.new
    tetris.place_piece(5, piece)
    saved_count = tetris.grid.flatten.count(true)
    tetris.shift_current_piece(-1) 
    saved_count.should eq(tetris.grid.flatten.count(true))
  end

  it "the current piece can shift right" do
    piece = Tetris::Piece.new(SQUARE)
    tetris = Tetris.new
    tetris.place_piece(5, piece)
    saved_count = tetris.grid.flatten.count(true)
    tetris.shift_current_piece(1) 
    saved_count.should eq(tetris.grid.flatten.count(true))
  end

end


