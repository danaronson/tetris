DEFAULT_WIDTH = 10
DEFAULT_HEIGHT = 10 


# a tetris game contains a grid of filled positions
# 0,0 is at the lower left corner and x is to the right and y is up

# it contains a current piece that has a shape and an x,y coordinate

class Tetris


  class Piece
    # a grid is a two dimension grid with true values where it is filled in
    def initialize(grid)
      @grid = grid
    end

    def grid
      return @grid
    end
  end
      
  # create the game which has a grid of booleans (width,heigth)
  def initialize(width = DEFAULT_WIDTH, height = DEFAULT_HEIGHT)
    @grid = Array.new(width) { Array.new(width) }
    0.upto(width-1) {|i| 0.upto(height-1) {|j| @grid[i][j] = false}}
  end

  # no reason that we have to store the width and height from variables, we can just get it from the grid dimensions
  def width
    return @grid.length
  end

  def height
    return @grid[0].length
  end

  # we need to access the grid to be able to reason about it
  def grid
    return @grid
  end

  # this takes a Tetris::Piece and places it at location x (counting from the left with a 0 index).
  # the number of rows that it takes up is dependent on the height of the piece
  # after we execute this, @current_piece is the Tetris::Piece and
  # @current_piece_position is the x,y coordinate in the Tetris grid of the lower left corner of the piece

  def place_piece(x, piece)
    raise RangeError if x < 0 or x >= @grid.length
    @current_piece = piece
    piece_grid = piece.grid
    0.upto(piece_grid.length - 1) {|i| 0.upto(piece_grid[0].length - 1) {|j| @grid[i + x][j+grid[0].length - 2] = piece_grid[i][j]}}
    @current_piece_position = [x, @grid[0].length - 2]
  end

  # do an ascii display of grid 0,0 at lower left, "+" for filled, "-" for not filled

  def display(grid=@grid)
    print "\n"
    (grid[0].length-1).downto(0) do |j| 
      row = ""
      0.upto(grid.length - 1) { |i| row += grid[i][j] ? "+" :"-" }
      print row, "\n"
    end
  end


  # this routine allows us to shift the current piece left or right in the tetris grid.  We use a temporary grid 
  # while shifting to simplify the logic so we don't have to worry in what order we do the copying of the grid coordinates

  def shift_current_piece(x)
    # make sure it doesn't shift too far left
    raise RangeError if 0 > @current_piece_position[0] + x
    # make sure it doesn't shift too far right
    raise RangeError if @current_piece_position[0] + @current_piece.grid.length >= @grid.length
    new_grid = @grid.clone
    # ok to do, copy the grid pieces
    0.upto(@current_piece.grid[0].length - 1) do |j|
      0.upto(@current_piece.grid.length - 1) do |i|
        new_grid[i+@current_piece_position[0]+x][j+@current_piece_position[1]] = grid[i+@current_piece_position[0]][j+@current_piece_position[1]]

      end
    end
    # clear out the column that we vacated
    column_to_clear = @current_piece_position[0]
    column_to_clear +=  + @current_piece.grid.length - 1 if x < 0
    0.upto(@current_piece.grid.length - 1) do |j|
      new_grid[column_to_clear][@current_piece_position[1]+j] = false
    end
    @current_piece_position[0] += x
    @grid = new_grid
  end
    
        

  def current_piece_position
    @current_piece_position
  end
end
