#! /bin/env ruby

FILE_INPUT = "./input_teste.txt"
SPLITTER = "^"
BEAM = "|"
START = "S"

require 'byebug'


class Cache

    def initialize
        @cache = {}
    end

    def has_key?(key)
        if @cache.has_key?(key)
            #puts "CACHE HIT: #{key}"
            true
        else
            #puts "CACHE MISS: #{key}"
            false
        end
    end

    def [](key)
        @cache[key]
    end

    def []=(key, value)
        @cache[key] = value
    end
end

@cache = Cache.new


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


def find_timelines(diagram, beam, timelines, map, line_number, path)
    if diagram.empty?
        timelines << beam
        map[-1][beam] = BEAM
        #puts_map(map)
        #byebug
        hash_key = "#{line_number},#{beam}"
        @cache[hash_key] = timelines
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
            left_path = splitter - 1
            right_path = splitter + 1
            map_left[line_number][left_path] = BEAM
            map_right[line_number][right_path] = BEAM

            left_hash = "#{line_number},#{left_path}"
            right_hash = "#{line_number},#{right_path}"

            #byebug if @cache.keys.size > 0
            if @cache.has_key?(left_hash)
                new_timelines = @cache[left_hash]
            else
                byebug
                new_timelines = path +  find_timelines(diagram[1..-1], left_path, timelines, map_left, line_number + 1, path + [left_path])
                @cache[left_hash] = new_timelines
            end

            if @cache.has_key?(right_hash)
                new_timelines = @cache[right_hash]
            else
                new_timelines = path +  find_timelines(diagram[1..-1], right_path, new_timelines, map_right, line_number + 1, path + [right_path])
                @cache[right_hash] = new_timelines
            end
        end
    end
    unless has_split
        new_map = dup_map(map)
        new_map[line_number][beam] = BEAM

        beam_hash = "#{line_number},#{beam}"

        if @cache.has_key?(beam_hash)
            new_timelines = @cache[beam_hash]
        else
            new_timelines = path + find_timelines(diagram[1..-1], beam, timelines, new_map, line_number + 1, (path + [beam]))
            @cache[beam_hash] = new_timelines
        end 
    end
    return new_timelines
end




timelines = find_timelines(input[1..-1], start_index, timelines, map, 1, [start_index])

count = timelines.size

#byebug

puts(count)