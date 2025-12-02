#! /bin/env ruby


def repeated?(num)
    digits = (Math.log(num, 10) + 1).floor
    return false if digits.odd?
    half = digits / 2
    first_half = num / 10.pow(half)
    second_half = num.modulo(10.pow(half))
    first_half == second_half
end

def invalid_ids(range)
    first, last = *range
    (first..last).select do |num|
        repeated?(num)
    end
end


input = File.read('./input.txt')

ranges = input.split(",").map { |range| range.split("-").map(&:to_i) }

puts ranges.reduce(0) { |memo, range| memo + invalid_ids(range).sum }

