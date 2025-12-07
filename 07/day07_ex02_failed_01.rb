#! /bin/env ruby

FILE_INPUT = "./input.txt"
SPLITTER = "^"
BEAM = "|"
START = "S"

require 'byebug'


def find_splitters(line)
    line.map.with_index do |char, index|
        if char == SPLITTER
            index
        else
            nil
        end
    end.select { |e| !e.nil?}
end

def dup_map(map)
    map.map(&:clone)
end


input = File.readlines(FILE_INPUT, chomp: true).map { |line| line.split("")}

map = dup_map(input)

start_index = input[0].find_index(START)

timelines = []

def puts_map(map)
    puts "=" * 80
    map.map { |m| puts m.join }
    puts "=" * 80
end


def find_timelines(diagram, beam, timelines, map, line_number)
    if diagram.empty?
        timelines << beam
        map[-1][beam] = BEAM
        #puts_map(map)
        return timelines
    end
    has_split = false
    new_timelines = []
    
    first_line = diagram[0]
    
    byebug if first_line.nil?

    splitters = find_splitters(first_line)
    splitters.each do |splitter|
        if beam == splitter
            has_split = true
            map_left = dup_map(map)
            map_right = dup_map(map)
            map_left[line_number][splitter - 1] = BEAM
            map_right[line_number][splitter + 1] = BEAM
            new_timelines = find_timelines(diagram[1..-1], splitter - 1, timelines, map_left, line_number + 1)
            new_timelines = find_timelines(diagram[1..-1], splitter + 1, new_timelines, map_right, line_number  + 1)
        end
    end
    unless has_split
        new_map = dup_map(map)
        new_map[line_number][beam] = BEAM
        new_timelines =  find_timelines(diagram[1..-1], beam, timelines, new_map, line_number + 1) 
    end
    new_timelines
end

find_timelines(input[1..-1], start_index, timelines, map, 1)

count = timelines.size

puts(count)