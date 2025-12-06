#! /bin/env ruby

INPUT_FILE = './input.txt'

input = File.readlines(INPUT_FILE, chomp: true)

operands_lines = input[0...-1]

operators = input[-1].split(" ")

max_power = operands_lines.size - 1


operands_wide = operands_lines.max_by { |line| line.size }.size

index = 0
sum = 0
numbers = []

auditoria = []

operands_wide.times do |char_index|
    power = 0
    all_blank = true

    number = 0
    operands_lines.reverse.each do |line|
        if line[char_index] != ' '
            all_blank = false
            number += line[char_index].to_i * 10.pow(power)
            power += 1
        end
    end

    if char_index == operands_wide - 1
        numbers << number
    end

    if all_blank || char_index == operands_wide - 1
        if operators[index] == '*'
            operacao = numbers.reduce(1) { |memo, n| memo * n }
        else
            operacao = numbers.reduce(0) { |memo, n| memo + n }
        end
        sum += operacao
        auditoria << {operador: operators[index], numeros: numbers, operacao: operacao}
        index += 1
        numbers = []

    else
        numbers << number
    end
end

puts(auditoria)
puts(sum)