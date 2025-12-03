#! /bin/env ruby

puts(File.readlines('./input.txt').map do |line|
    bank = line.strip.split("")
    bank.map!(&:to_i)

    first_battery = bank[0...-1].max
    index_max = bank.find_index(first_battery)
    second_battery = bank[(index_max + 1)..-1].max

    (first_battery * 10) + second_battery
end.to_a.sum)