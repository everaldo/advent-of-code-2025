#!/bin/env ruby

require 'byebug'
require 'forwardable'

INPUT_FILE = "./input_teste.txt"

class Present
    extend Forwardable

    attr_accessor :id, :shape, :label

    def_delegators :@shape, :[], :size, :each

    def initialize(id, shape, label = '#')
        @id = id
        if shape[0][0].is_a?(String)
            @shape = shape.map { |s| s.map {|e| e == '#' }.freeze }.freeze
        else
            @shape = shape.map { |s| s.dup }.freeze
        end
        @label = label
    end

    def variations
        all_rotations.map { |r| r.all_flips }.flatten.uniq { |s| s.to_s }
    end

    def rotate
        rotated_matrix = shape.transpose.map! { |l| l.reverse! }
        self.class.new(id, rotated_matrix, label)
    end

    def all_rotations
        rotate_90 = rotate
        rotate_180 = rotate_90.rotate
        rotate_270 = rotate_180.rotate

        [self, rotate_90, rotate_180, rotate_270]
    end

    def all_flips
        [self, self.flip_horizontal, self.flip_vertical]
    end

    def flip_horizontal
        flip_horizontal_matrix = shape.map { |l| l.reverse }
        self.class.new(id, flip_horizontal_matrix, label)
    end

    def flip_vertical
        flip_vertical_matrix = shape.reverse
        self.class.new(id, flip_vertical_matrix, label)
    end

    def <=>(other)
        id == other.id && to_s <=> other.to_s
    end

    def to_s
        str = []

        str << "#{id}:\n"
        shape.each do |line|
            line.each do |char|
                str << "#{char ? label : "."}"
            end
            str << "\n"
        end
        str << "\n"
        str.join
    end
end

class Section
    attr_reader :width, :height, :grid, :presents, :presents_needed

    def initialize(width, height, presents, presents_needed, grid = [])
        @width = width
        @height = height
        @presents = presents
        if grid.empty?
            @grid =  Array.new(width).map { |i| Array.new(height, false).freeze  }.freeze
        else
            @grid = grid.map { |line| line.freeze }.freeze
        end
        @presents_needed = presents_needed .freeze
    end

    def fit_all_presents?
        return true if presents_needed.all?(&:zero?)

        present_index = presents_needed.find_index { |p| !p.zero? }
        present = presents[present_index]
        variations = present.variations

        variations.any? do |present_variation|
            if coords = fit?(present_variation)
                new_section = place_present(present, coords)
                new_section.fit_all_presents?
            end
        end
    end

    def place_present(present, coords)
        i, j = coords
        size = present.size

        new_grid = @grid.map { |line| line.dup }

        size.times do |m|
            size.times do |n|
                if present[m][n]
                    new_grid[i + m][j + n] = true
                end
            end
        end

        new_presents = presents_needed.dup

        index = present.id

        new_presents[index] -= 1

        self.class.new(width, height, presents, new_presents, new_grid)
    end

    def fit?(present) # se necessário pesquisar apenas um subgrid, adicionar p e q
        size = present.size

        (width - size + 1).times do |i|
            (height - size + 1).times do |j|
                is_fit = true
                
                size.times do |m|
                    size.times do |n|
                        if present[m][n] && grid[i + m][j + n]
                            is_fit = false
                            break
                        end
                    end
                end
                return [i, j] if is_fit                
            end
        end
        false
    end

    def to_s
        str = []

        grid.each do |line|
            line.each do |cell|
                str << "#{cell ? "#" : "."}"
            end
            str << "\n"
        end
        str << "\n"
        str.join
    end
end



#p = Present.new(1, [["#", ".", "."], [".", ".", "."], [".", ".", "#"]])


input = File.read(ARGV[0] || INPUT_FILE)


presents_regexp = /(\d+):\n([#.]{3}\n[#.]{3}\n[#.]{3})/

sections_regexp = /(\d+)x(\d+): ([\d ]+)/


presents = input.scan(presents_regexp)

presents.map! { |present|  Present.new(present[0].to_i, present[1].split("\n").map { |s| s.split("") } ) }

presents.freeze

sections = input.scan(sections_regexp)

sections.map! { |section| {width: section[0].to_i, height: section[1].to_i, presents_needed: section[2].split(" ").map(&:to_i)} }


sections.map! { |section|  Section.new(section[:width], section[:height], presents, section[:presents_needed]) }


count = sections.count(&:fit_all_presents?)

byebug

puts input.inspect