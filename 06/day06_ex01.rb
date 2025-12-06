#! /bin/env ruby

INPUT_FILE = './input.txt'

require 'byebug'


input = File.readlines(INPUT_FILE, chomp: true).each do |line|
    line.strip!
    line.gsub!(/\s+/, ' ')
end

operands = input[0...-1].map do |line|
    line.split(" ").map(&:to_i)
end

operators = input[-1].split(" ")

operands = operands.transpose


sum = operators.map.with_index do |operator, index|
    if operator == '*'
        operands[index].reduce(1) { |memo, i| i * memo}
    else
        operands[index].reduce(0) { |memo, i| i + memo}
    end
end.sum

puts sum