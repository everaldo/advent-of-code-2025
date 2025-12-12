#! /bin/env ruby

require 'byebug'

INPUT_FILE = "./input_ex02_teste.txt"

@memo = {}

def count_paths_dac_and_fft(hash, start, visited)

    neighboors = hash[start]

    neighboors.map do |neighboor|
        next 0 if visited.member?(neighboor)

        new_visited = visited | [neighboor]
        fft_visited = new_visited.member?(:fft) || neighboor == :fft 
        dac_visited = new_visited.member?(:dac) || neighboor == :dac 

        cache_key = "#{neighboor}_#{fft_visited}_#{dac_visited}"

        next @memo[cache_key] if @memo.has_key?(cache_key)

        if neighboor == :out
            if fft_visited && dac_visited
                next @memo[cache_key] = 1
            end
            next @memo[cache_key] = 0
        end



        @memo[cache_key] = count_paths_dac_and_fft(hash, neighboor, new_visited)
    end.sum
end


input = File.readlines(ARGV[0] || INPUT_FILE, chomp: true)

hash = {}

input.each do |line|
    key, values = line.split(":")
    hash[key.to_sym] = values.split(" ").map(&:to_sym)
end

#byebug

puts count_paths_dac_and_fft(hash, :svr, [])
