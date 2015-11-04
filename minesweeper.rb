class ValueError < StandardError
end  

class Board
  def self.transform(input)
    validate_input(input)
    output = Array.new(input.size) { Array.new(input[0].size) }

    input.each_with_index do |row, x|
      row.chars.each_with_index do |character, y|
        if character != ' '
          output[x][y] = character
        else  
          output[x][y] = number_of_surrounding_mines(x, y, input)
        end  
      end
    end
    output.map(&:join)
  end

  def self.number_of_surrounding_mines(x, y, input)
    mines_to_left_and_right = [input[x][y - 1], input[x][y + 1]]
    mines_directly_above_and_below = [input[x - 1][y], input[x + 1][y]]
    mines_diagonally_above_and_below = [input[x - 1][y - 1], input[x - 1][y + 1], input[x + 1][y - 1], input[x + 1][y + 1]]
    number_of_mines = (mines_to_left_and_right + mines_directly_above_and_below + mines_diagonally_above_and_below).count('*')
    number_of_mines == 0 ? ' ' : number_of_mines.to_s
  end

  def self.validate_input(input)
    fail ValueError, 'All rows must be the same length' unless rows_of_the_same_length?(input)
    fail ValueError, 'Invalid board pattern' unless valid_board_pattern?(input)
  end

  def self.rows_of_the_same_length?(input)
    input.map(&:length).uniq.length == 1
  end

  def self.valid_board_pattern?(input)
    first_row, last_row = input[0], input[-1]
    first_row.match(/^\+-*\+$/) && last_row.match(/^\+-*\+$/) && valid_middle_rows?(input)
  end

  def self.valid_middle_rows?(input)
    input[1..-2].all? {|row| row.match(/^\|(\*|\ )*\|$/)}
  end
end