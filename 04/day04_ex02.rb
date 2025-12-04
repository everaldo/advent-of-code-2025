#! /bin/env ruby

INPUT_FILE = './input.txt'
PAPER_ROLL = '@'
EMPTY_CELL = '.'
REMOVED = 'X'

require 'byebug'

def count_adjacent(grid, i, j)
    count = 0
    (-1..1).each do |n|
        (-1..1).each do |m|
            next if n == 0 && m == 0
            next if  i + n < 0
            next if j + m < 0
            next if i + n >= grid.size
            next if j + m >= grid.size
            count += 1 if grid[i + n][j + m] == PAPER_ROLL
        end
    end
    count
end

def removed_marked(grid, marked_to_remove)
    marked_to_remove.each do |i, j|
        grid[i][j] = REMOVED
    end
end


grid = File.readlines(INPUT_FILE).map do |line|
    line.strip.split("")
end

total = 0

begin
    marked_to_remove = []

    grid.each_with_index do |line, i|
        line.each_with_index do |cell, j|
            next if cell != PAPER_ROLL
            if count_adjacent(grid, i, j) < 4
                marked_to_remove << [i, j]
            end
        end
    end
    total += marked_to_remove.size
    removed_marked(grid, marked_to_remove)
end while marked_to_remove.size != 0


puts total