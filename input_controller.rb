require_relative '../models/game_board'
require_relative '../models/ship'
require_relative '../models/position'

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)
    #Create a gameboard size 10x10 and populate it using add ship
    #Return gameboard if there are 5 valid ships (add the first 5)
    #Return nil if there arent 5 valid ships

    ships = 0
    counter = 0
    board2 = GameBoard.new 10, 10

    #If the file is valid
    if read_file_lines(path) == true

        #Read the file with the function below
        read_file_lines(path) {|line|
            if line =~ /^(\((10|[1-9])),((10|[1-9])\)), (Up|Down|Right|Left), ([1-5])$/

            #If the line matches, put the info in capture groups
            row = $2 #row
            row = row.to_i
            col = $4 #col
            col = col.to_i
            orientation = $5 #orientation
            size = $6 #size
            size = size.to_i

            pos = Position.new(row, col)
            ship = Ship.new(pos, orientation, size)
            puts ship
           
            flag = board2.add_ship(ship)

            board2.to_s
            #Skip a line if it doesn't fit the prescribed format, aka only add if format is good
            if flag == true
                counter = counter + 1
            end
            puts counter

            if counter == 5
                return board2
            end
        end
        }
        return nil
    end
    return nil
 end


# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
    
    arr = Array.new()

    if read_file_lines(path) == true

        #Reads the file and adds the positions to array
        read_file_lines(path) {|line|
        if line =~ /^(\((10|[1-9])),((10|[1-9])\))$/
            row = $2.to_i
            col = $4.to_i
            pos = Position.new(row, col)
            arr.push(pos)
        end
        }
        #puts arr
        return arr
    end
    #Return nil if the file doesn't exist
    return nil
end


# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
    return false unless File.exist? path
    if block_given?
        File.open(path).each do |line|
            yield line
        end
    end

    true
end
