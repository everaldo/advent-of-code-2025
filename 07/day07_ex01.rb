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


input = File.readlines(FILE_INPUT, chomp: true).map { |line| line.split("")}

start_index = input[0].find_index(START)

beams = [start_index]

count = 0

input[1..-1].each do |line|
    splitters = find_splitters(line)
    new_beams = []
    splitted = []

    beams.each do |beam|
        splitters.each do |splitter|
            if beam == splitter
                count += 1
                new_beams.concat([splitter - 1, splitter + 1])
                splitted << beam
            end
        end
    end

    beams = beams.concat(new_beams).uniq - splitted
end

puts(count)