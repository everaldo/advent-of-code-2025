#! /bin/env ruby

INPUT_FILE = './input.txt'

input = File.readlines(INPUT_FILE)

separator_index = input.find_index("\n")

fresh_ingredient_id_ranges = input[0...separator_index]

available_ingredient_ids = input[separator_index+1..-1]


fresh_ingredient_id_ranges.map!(&:strip!).map! { |range_str| Range.new(*range_str.split("-").map!(&:to_i)) }

available_ingredient_ids.map!(&:to_i)

puts(available_ingredient_ids.reduce(0) do |memo, id| 
    if fresh_ingredient_id_ranges.any? { |range| range.cover?(id) }
        memo += 1
    end
    memo
end
)
