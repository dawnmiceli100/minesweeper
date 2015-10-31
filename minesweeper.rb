class Board

  def self.transform(input_board)
    @@input_board = input_board
    validate_input
    @@transformed_board = create_transformed_board
  end 

  private

  def self.validate_input
    check_for_line_length_error
    check_for_border_errors
    check_for_invalid_characters_in_middle_lines(@@input_board[1..-2])
  end
    
  def self.check_for_line_length_error 
    line_lengths = @@input_board.map { |line| line.length }
    if line_lengths.uniq.length > 1
      raise ValueError.new("Length of each input line must be the same.") 
    end  
  end 

  def self.check_for_border_errors
    check_border_line(@@input_board.first)
    check_border_line(@@input_board.last)
    check_borders_of_middle_lines(@@input_board[1..-2])
  end  

  def self.check_border_line(border_line)
    if !border_line.start_with?('+') || !border_line.end_with?('+')
      raise ValueError.new("Top and bottom border must begin and end with '+'.")
    end 

    unique_middle_characters = border_line[1..-2].chars.uniq
    if unique_middle_characters.length > 1 || unique_middle_characters != ['-']
      raise ValueError.new("Invalid characters in top or bottom border.")
    end  
  end 

  def self.check_borders_of_middle_lines(middle_lines) 
    border_characters = middle_lines.map { |line| line.chars.first + line.chars.last }
    if border_characters.uniq.length > 1 || border_characters.uniq != ['||']
      raise ValueError.new("Middle input lines must begin and end with '|'.")
    end  
  end  

  def self.check_for_invalid_characters_in_middle_lines(middle_lines)
    unique_non_border_characters = (middle_lines.map { |line| (line[1..-2].chars.uniq) }).flatten.uniq
    if unique_non_border_characters.join.strip != "*"
      raise ValueError.new("Non border characters must be '*' or blank.")
    end  
  end 

  def self.create_transformed_board
    @@transformed_board = []
    number_of_lines = @@input_board.length
    @@input_board.map.with_index do |line, index|
      write_line_with_clues(line, index, number_of_lines)
    end 
    return @@transformed_board
  end 

  def self.write_line_with_clues(line, index_of_line, number_of_lines)
    if index_of_line == 0 || index_of_line == number_of_lines - 1
      @@transformed_board << @@input_board[index_of_line]
    else
      @@transformed_line = ''
      line.chars.map.with_index do |character, index_of_character| 
        if (character == '|') || (character == '*')
          @@transformed_line << character
        else
          @@mine_count = 0
          find_mines_to_left_and_right(index_of_line, index_of_character)
          case index_of_line
          when 1
            find_mines_below(index_of_line, index_of_character)
          when number_of_lines - 2 
            find_mines_above(index_of_line, index_of_character)
          else
            find_mines_above(index_of_line, index_of_character)
            find_mines_below(index_of_line, index_of_character)
          end     
          if @@mine_count == 0
            @@clue = ' '  
          else
            @@clue = @@mine_count.to_s
          end
          @@transformed_line << @@clue    
        end  
      end 
      @@transformed_board << @@transformed_line 
    end   
  end 

  def self.find_mines_to_left_and_right(index_of_line, index_of_character)
    if @@input_board[index_of_line][index_of_character - 1] == '*'
      @@mine_count += 1
    end  
    if @@input_board[index_of_line][index_of_character + 1] == '*'
      @@mine_count += 1
    end  
  end 

  def self.find_mines_below(index_of_line, index_of_character)
    if @@input_board[index_of_line + 1][index_of_character] == '*'
      @@mine_count += 1
    end
    find_diagonal_mines_below(index_of_line, index_of_character)
  end

  def self.find_diagonal_mines_below(index_of_line, index_of_character) 
    if @@input_board[index_of_line + 1][index_of_character - 1] == '*'
      @@mine_count += 1
    end 
    if @@input_board[index_of_line + 1][index_of_character + 1] == '*'
      @@mine_count += 1
    end   
  end 

  def self.find_mines_above(index_of_line, index_of_character)
    if @@input_board[index_of_line - 1][index_of_character] == '*'
      @@mine_count += 1
    end
    find_diagonal_mines_above(index_of_line, index_of_character)
  end  

  def self.find_diagonal_mines_above(index_of_line, index_of_character) 
    if @@input_board[index_of_line - 1][index_of_character - 1] == '*'
      @@mine_count += 1
    end 
    if @@input_board[index_of_line - 1][index_of_character + 1] == '*'
      @@mine_count += 1
    end   
  end 
end

class ValueError < StandardError
  def initialize(message)
    @message = message
  end  
end  