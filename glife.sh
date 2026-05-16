#!/bin/bash

# ==============================================================================
# Conway's Game of Life
# RISC-V Mentorship Coding Challenge
# Iteration-based grid simulation in Bash
# Author: Geethika Prabhath
# ==============================================================================

# Grid Size
ROWS=20
COLS=20

# Associative Arrays for handling 2D matrices
declare -A curr_grid
declare -A next_grid

###### INITIALIZING THE STARTING CELL CONFIG OF GOL ######
initialize_grid() { 
    # Create a random grid around the middle of the desired grid
    # 1. Set all cells to 0 at first - ITERATION
    for ((r=0; r<ROWS; r++)); do
        for ((c=0; c<COLS; c++)); do
            curr_grid["$r,$c"]=0
        done
    done

    # 2. Find the middle coordinates
    local mid_r=$(( ROWS / 2 ))
    local mid_c=$(( COLS / 2 ))

    # 3. Run a nested loop around middle for a decided window- ITERATION
    for ((mr=-2; mr<=2; mr++)); do # change the window size by adjusting the range
        for ((mc=-2; mc<=2; mc++)); do

            # Randomly fill the 9 cells
            curr_grid[$(( mid_r + mr )),$(( mid_c + mc ))]=$(( RANDOM % 2 ))
        done
    done
}

###### DISPLAYING THE GRID ######
display_grid() {
    # ANSI escape sequence: Moves cursor to home (top left) without wiping buffer.
    # To prevent visual glitches on the terminal.
    printf "\033[H"
    
    # Loop through the current grid object and build the stdout for each 'line' - ITERATION
    for ((r=0; r<ROWS; r++)); do
        local line=""
        for ((c=0; c<COLS; c++)); do
            if [[ ${curr_grid["$r,$c"]} -eq 1 ]]; then
                line+="█" # Unicode block -> alive cell
            else
                line+=" " # Blank space -> dead cell
            fi
        done
        echo "$line"
    done
}

###### COUNTING NEIGHBOURS FOR A CELL ######
count_neighbors() {
    local current_r=$1
    local current_c=$2
    local count=0

    # 3x3 window loop scanning adjacent cells status - COSTLY ITERATION for each cell called
    for ((dr=-1; dr<=1; dr++)); do
        for ((dc=-1; dc<=1; dc++)); do
            # Skip if origial cell (middle)
            if [[ $dr -eq 0 && $dc -eq 0 ]]; then
                continue
            fi

            # Calculate the cordinates of the neighbor with wrap-around
            local nr=$(( (current_r + dr + ROWS) % ROWS ))
            local nc=$(( (current_c + dc + COLS) % COLS ))

            if [[ ${curr_grid["$nr,$nc"]} -eq 1 ]]; then
                ((count++))
            fi
        done
    done
    echo "$count"
}

###### GAME OF LIFE LOGIC: UPDATE THE GRID TO THE NEXT GENERATION ######
update_grid() {
    # Determine the next state of each cell based on the current grid - ITERATION
    # Calculate for a separate grid object to simulate simultaneous change
    for ((r=0; r<ROWS; r++)); do
        for ((c=0; c<COLS; c++)); do
            local cell_status=${curr_grid["$r,$c"]}
            local alive_neighbors
            
            # Count alive neighbours
            alive_neighbors=$(count_neighbors $r $c)

            if [[ $cell_status -eq 1 ]]; then
                # Rule 1 or 2 - Underpopulation or Overpopulation -> death
                if [[ $alive_neighbors -lt 2 || $alive_neighbors -gt 3 ]]; then
                    next_grid["$r,$c"]=0
                else
                    next_grid["$r,$c"]=1 # Survive
                fi
            else
                # Rule 3 - Reproduction -> birth
                if [[ $alive_neighbors -eq 3 ]]; then
                    next_grid["$r,$c"]=1
                else
                    next_grid["$r,$c"]=0
                fi
            fi
        done
    done

    # Syncing the changes to the main grid object - ITERATION
    for ((r=0; r<ROWS; r++)); do
        for ((c=0; c<COLS; c++)); do
            curr_grid["$r,$c"]=${next_grid["$r,$c"]}
        done
    done
}

###### MAIN ######
main() {
    clear # Clear terminal
    initialize_grid
    
    # Infinite game of life loop - MAIN ITERATION
    while true; do
        display_grid
        update_grid
        sleep 0.1 # Speed of change
    done
}

main