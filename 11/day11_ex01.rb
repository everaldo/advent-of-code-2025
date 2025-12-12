#! /bin/env ruby

require 'byebug'

INPUT_FILE = "./input_teste.txt"

def count_paths(hash, start)

    neighboors = hash[start]

    neighboors.map do |neighboor|
        return 1 if neighboor == :out

        count_paths(hash, neighboor)
    end.sum
end


input = File.readlines(ARGV[0] || INPUT_FILE, chomp: true)

hash = {}

input.each do |line|
    key, values = line.split(":")
    hash[key.to_sym] = values.split(" ").map(&:to_sym)
end

puts count_paths(hash, :you)
