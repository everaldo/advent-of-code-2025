#! /bin/env ruby

require 'byebug'

def repeated?(num, digits, digit)
    first_n_digits = num / 10.pow(digits - digit)
    return false if first_n_digits.zero?

    rest = num % 10.pow(digits - count_digits(first_n_digits))
    rest_digits = count_digits(rest)

    # detecta zero à esquerda no resto
    return false if (digits - digit) != rest_digits

    check?(first_n_digits, rest)
end

def count_digits(num)
    return 1 if num.zero?
    (Math.log(num, 10) + 1).floor
end

def check?(sequence, num)
    sequence_digits = count_digits(sequence)
    num_digits = count_digits(num)
    first_n_digits_num =  num / 10.pow(num_digits - sequence_digits)

    first_n_digits_num_digits = count_digits(first_n_digits_num)

    return false if sequence_digits != first_n_digits_num_digits

    return false if first_n_digits_num.zero?

    if sequence_digits == num_digits
        return sequence == first_n_digits_num
    end

    return false if sequence_digits > num_digits


    rest = num % 10.pow(num_digits - sequence_digits)

    rest_digits = count_digits(rest)

    return false if rest_digits != (num_digits - sequence_digits)
    
    sequence == first_n_digits_num && check?(sequence, rest)
end

def invalid_ids(range)
    first, last = *range
    (first..last).select do |num|
        # verificar sequência de 1 até metade dos digitos de num
        digits = count_digits(num)
        half_digits = (digits / 2).floor
        (1..half_digits).any? do |digit|
            repeated?(num, digits, digit)
        end
    end
end



#invalid_ids([444,444])

input = File.read('./input.txt')

ranges = input.split(",").map { |range| range.split("-").map(&:to_i) }

puts ranges.reduce(0) { |memo, range| memo + invalid_ids(range).sum }

