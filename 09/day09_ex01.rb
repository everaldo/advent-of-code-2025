#! /bin/env ruby

INPUT_FILE = "./input.txt"

require 'byebug'

tiles = File.readlines(ARGV[0] || INPUT_FILE, chomp: true).map do |line|
    line.split(",").map(&:to_i)
end

areas = []

tiles.combination(2) do |coords|
    coords in [p0, p1]
    [p0, p1] in [[y0, x0], [y1, x1]]
    area = ((y0 - y1).abs + 1) * ((x0 - x1).abs + 1)
    areas << {area: area, p0: p0, p1: p1}
end

max_area = areas.max_by { |area| area[:area] }

puts max_area[:area].inspect