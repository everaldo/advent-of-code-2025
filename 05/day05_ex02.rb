#! /bin/env ruby

INPUT_FILE = './input.txt'


require 'byebug'

def range_overlap(range, computed_ranges)
    if computed_ranges.empty?
        computed_ranges << range
        return [range.size, computed_ranges]
    end

    #byebug if range.last < range.first

    first_computed_range = computed_ranges[0]
    rest_computed_ranges = computed_ranges[1..-1]

    return [0, computed_ranges] if first_computed_range.cover?(range)

    if range.cover?(first_computed_range)
        left = range_overlap(Range.new(range.first, first_computed_range.first - 1), computed_ranges)
        right = range_overlap(Range.new(first_computed_range.last + 1, range.last), computed_ranges)
        return [left[0] + right[0], computed_ranges.concat(left[1].concat(right[1])).uniq]        
    end

    if first_computed_range.overlap?(range)
        first, last = first_computed_range.minmax

        if range.cover?(first) && first != last
            # new_range = range.first , first - 1
            aux = range_overlap(Range.new(range.first, first - 1), rest_computed_ranges)
            [aux[0], computed_ranges.concat(aux[1]).uniq]
        else
            # new_range = last + 1, range.last
            aux = range_overlap(Range.new(last + 1, range.last), rest_computed_ranges)
            [aux[0], computed_ranges.concat(aux[1]).uniq]
        end
    else
        begin
            aux = range_overlap(range, rest_computed_ranges)
            [aux[0], computed_ranges.concat(aux[1]).uniq]
        rescue Exception => ex
            byebug
        end
    end
end

def count_ids(ranges, computed_ranges, count)
    return count if ranges.empty?

    first = ranges[0]
    rest  = ranges[1..-1]

    new_range_size, computed_ranges = range_overlap(first, computed_ranges)
    #unless new_range.nil?
    #    computed_ranges << new_range 
    #    new_range_size = new_range.size
    #else
    #    new_range_size = 0
    #end

    #puts("new_range_size=#{new_range_size}, computed_ranges=#{computed_ranges.inspect}")

    count_ids(rest, computed_ranges, count + new_range_size)
end


input = File.readlines(INPUT_FILE)

separator_index = input.find_index("\n")

fresh_ingredient_id_ranges = input[0...separator_index]

fresh_ingredient_id_ranges.map!(&:strip!).map! { |range_str| Range.new(*range_str.split("-").map!(&:to_i)) }


computed_ranges = []


#fresh_ingredient_id_ranges.each do |range|
#    puts range if range.first == range.last

#end

#byebug
puts count_ids(fresh_ingredient_id_ranges, computed_ranges, 0)

#puts(computed_ranges.map { |r| [r, r.size]}.inspect)