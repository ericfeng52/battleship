class GameBoard
    
    # @max_row is an `Integer`
    # @max_column is an `Integer`
    attr_reader :max_row, :max_column

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column

        # Gameboard initialize
        @gameboard = Array.new(@max_row){Array.new(@max_column) {["-","-"]}}

    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        @ship = ship
        coord = Array.new(@ship.size) # Array of all ship coord
        first_pos = Position.new(@ship.start_position.row - 1, @ship.start_position.column - 1) # Offset 1 for position to index
        orientation = ship.orientation
        coord[0] = first_pos
        temp_row = first_pos.row # Temp variables
        temp_col = first_pos.column 
        counter = 1

        # Fill in array of ships coordinates, temp_pos[0] is across temp_pos[1] is up
        while counter < @ship.size do
            if orientation == "Up"
                temp_row = first_pos.row - counter
            elsif orientation == "Down"
                temp_row = first_pos.row + counter
            elsif orientation == "Left"
                temp_col = first_pos.column - counter
            elsif orientation == "Right"
                temp_col = first_pos.column + counter
            end
            temp_pos = Position.new(temp_row, temp_col)
            coord[counter] = temp_pos
            counter = counter + 1
            temp_row = first_pos.row
            temp_col = first_pos.column 
        end

        # Check for ship overlap2
        counter = 0
        while counter < @ship.size do 
            #puts ship
            #puts coord[counter].row
            #puts coord[counter].column
            if @gameboard[coord[counter].row][coord[counter].column][0] == "B"
                return false
            end
            counter = counter + 1
        end

        # Check if ship bleeds off gameboard
        counter = 0
        while counter < @ship.size do 
            if coord[counter].row > @max_row - 1 || coord[counter].row < 0 || coord[counter].column > @max_column - 1 || coord[counter].column < 0
                return false
            end
            counter = counter + 1
        end

        # All checks aite, add the ship
        counter = 0
        while counter < @ship.size do
            @gameboard[coord[counter].row][coord[counter].column][0] = "B"
            counter = counter + 1
        end
        return true
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)

        flag = false # Did we hit the ship????
        row_index = position.row - 1 # Offset for indicies
        col_index = position.column - 1

        # check position
        if row_index > @max_row - 1 || row_index < 0 || col_index > @max_column - 1 || col_index < 0
            return nil
        end

        # if the attack hit a ship flag is true
        if @gameboard[row_index][col_index][0] == "B"
            flag = true
            @gameboard[row_index][col_index][1] = "A"

        # if it didn't flag stays false
        elsif
            @gameboard[row_index][col_index][1] = "A"
        end

        # return whether the attack was successful or not
        return flag
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks

        curr_row = 0
        curr_col = 0
        hits = 0

        while curr_row < @max_row do
            curr_col = 0
            while curr_col < @max_column do
                if @gameboard[curr_row][curr_col][0] == "B" && @gameboard[curr_row][curr_col][1] == "A"
                    hits = hits + 1
                end
                curr_col = curr_col + 1
            end
            curr_row = curr_row + 1
        end

        return hits
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?

        curr_row = 0

        while curr_row < @max_row do
            curr_col = 0
            while curr_col < @max_column do
                if @gameboard[curr_row][curr_col][0] == "B" && @gameboard[curr_row][curr_col][1] != "A"
                    return false # Not all sunk, boat that hasn't been attacked
                end
                curr_col = curr_col + 1
            end
            curr_row = curr_row + 1
        end
        return true
    end


    # String representation of GameBoard (optional but recommended)
    def to_s
        
        curr_row = 0
        while curr_row < @max_row do
            curr_col = 0
            while curr_col < @max_column do
                print @gameboard[curr_row][curr_col]
                curr_col = curr_col + 1
            end
            print "\n"
            curr_row = curr_row + 1
        end

    end
end
