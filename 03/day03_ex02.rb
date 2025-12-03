#! /bin/env ruby

def find_max(accumulator, bank, total_digits)
    return accumulator + bank[0..-1].max if total_digits == 1

    max = bank[0..(bank.size - total_digits)].max

    new_start_index = bank.find_index(max) + 1

    accumulator = accumulator + (max * 10.pow(total_digits - 1))

    find_max(accumulator, bank[new_start_index..-1], total_digits - 1)
end


puts(File.readlines('./input.txt').map do |line|
    total_digits = 12
    bank = line.strip.split("")
    bank.map!(&:to_i)

    find_max(0, bank, 12)
end.sum)
