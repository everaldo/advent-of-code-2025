#! /bin/env ruby

FILE_INPUT = "./input.txt"
SPLITTER = "^"
BEAM = "|"
START = "S"

class Cache

    def initialize
        @cache = {}
    end

    def has_key?(key)
        @cache.has_key?(key)
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

def puts_map(map)
    puts "=" * 80
    map.map { |m| puts m.join }
    puts "=" * 80
end


def count_timelines(diagram, beam, map, line_number, path)
    if diagram.empty?
        map[-1][beam] = BEAM
        #puts_map(map)
        hash_key = "#{line_number},#{beam}"
        @cache[hash_key] = 1
        return 1
    end
    has_split = false
    
    first_line = diagram[0]

    count = 0
    
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

            hash_key = "#{line_number},#{splitter}"
            left_hash = "#{line_number},#{left_path}"
            right_hash = "#{line_number},#{right_path}"

            if @cache.has_key?(hash_key)
                return @cache[hash_key]
            else
                left_count = count_timelines(diagram[1..-1], left_path, map_left, line_number + 1, path + [left_path])
                right_count = count_timelines(diagram[1..-1], right_path, map_right, line_number + 1, path + [right_path])
                @cache[hash_key] = left_count + right_count
                return left_count + right_count
            end
        end
    end
    unless has_split
        new_map = dup_map(map)
        new_map[line_number][beam] = BEAM

        return count_timelines(diagram[1..-1], beam, new_map, line_number + 1, (path + [beam]))
    end
end

count = count_timelines(input[1..-1], start_index, map, 1, [start_index])

puts(count)