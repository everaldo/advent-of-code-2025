#!/bin/env ruby

require 'byebug'

def calculate_distance(a, b)
    Math.sqrt( (a[0] - b[0]).pow(2) + (a[1] - b[1]).pow(2) + (a[2] - b[2]).pow(2))
end


def calculate_distances(junction_boxes)
    distances = []

    junction_boxes.size.times do |i|
        distances[i] = []
        distances[i][i] = {a: i, b: i, distance: 0}
    end

    count = 0

    junction_boxes.each_with_index do |_, i|
        junction_boxes.each_with_index do |_, j|

            a = junction_boxes[i]
            b = junction_boxes[j]
            if i < j
                count += 1
                #puts("#{i}, #{j}")
                distance = calculate_distance(a, b)
                distances[i][j] = {a: i, b: j, distance: distance} 
                distances[j][i] = {a: j, b: i, distance: distance}
            end
        end
    end

    #junction_boxes.combination(2).each do |a, b|
    #    i = junction_boxes.find_index(a)
    #    j = junction_boxes.find_index(b)
    #    distance = calculate_distance(a, b)
    #    distances[i][j] = {a: i, b: j, distance: distance} 
    #    distances[j][i] = {a: j, b: i, distance: distance} 
    #end

    distances
end

def get_connections(distances)
    size = distances[0].size
    sorted = distances.flatten.sort_by { |v| [v[:distance], v[:a], v[:b]]  }
    sorted = sorted[size..-1]
    sorted = sorted.slice((0...sorted.size).step(2))
    sorted
end

def create_circuits_until_connected(junction_boxes, connections)
    circuits = []

    total_boxes = junction_boxes.size

    connections.each do |connection|
        connection in {a: a, b: b}

        circuit_a = circuits.find { |circuit| circuit.member?(a) }
        circuit_b = circuits.find { |circuit| circuit.member?(b) }
        
        if circuit_a.nil?
            if circuit_b.nil?
                circuit = [a, b]
                circuits << circuit
            else
                circuit_b.append(a)
            end
        else
            if circuit_b.nil?
                circuit_a.append(b)
            else
                if circuit_a != circuit_b
                    circuit_a.concat(circuit_b).uniq!
                    circuits.delete(circuit_b)
                end
            end
        end

        if circuits.map(&:size).max == total_boxes
            return connection
        end
    end
    nil
end


def print_distances(distances)
    distances.each do |row|
        row.each do |val|
            print("#{val[:distance].round(2)}".rjust(7))
        end
        print("\n")
    end
    print("\n")
end


junction_boxes = File.readlines(ARGV[0] || 'input.txt').map(&:chomp)

junction_boxes.map! { |jb| jb.split(",").map!(&:to_i) }

distances = calculate_distances(junction_boxes)

connections = get_connections(distances)

ponto_de_articulacao = create_circuits_until_connected(junction_boxes, connections)

x_coord = 0

puts(junction_boxes[ponto_de_articulacao[:a]][x_coord] * junction_boxes[ponto_de_articulacao[:b]][x_coord])


