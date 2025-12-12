#! /bin/env ruby

require 'byebug'
require 'matrix'

INPUT_FILE = "input_teste.txt"

def parse_machine(machine_hash)
    buttons = machine_hash[:buttons].split(" ").map! { |button_str| button_str.slice(1...-1).split(",").map(&:to_i) }
    joltage = machine_hash[:joltage].slice(1...-1).split(",").map(&:to_i)
    {
        buttons: buttons,
        joltage: joltage
    }
end

# Resolve sistema linear Ax = b usando eliminação gaussiana
# A = matriz de botões (cada coluna é um botão, cada linha é um contador)
# b = joltage (valores alvo)
# x = vetor de quantas vezes apertar cada botão
def solve_joltage(buttons, joltage)
    num_counters = joltage.size
    num_buttons = buttons.size

    # Monta matriz aumentada [A|b] usando Rational para precisão
    # Cada linha é um contador, cada coluna é um botão
    augmented = Array.new(num_counters) { |i|
        row = Array.new(num_buttons, Rational(0))
        buttons.each_with_index do |button, j|
            row[j] = Rational(1) if button.include?(i)
        end
        row << Rational(joltage[i])
        row
    }

    # Eliminação gaussiana com pivoteamento parcial
    pivot_row = 0
    num_buttons.times do |col|
        # Encontra pivot
        max_row = (pivot_row...num_counters).max_by { |r| augmented[r][col].abs }
        break if max_row.nil? || augmented[max_row][col] == 0

        # Troca linhas
        augmented[pivot_row], augmented[max_row] = augmented[max_row], augmented[pivot_row]

        # Elimina abaixo
        ((pivot_row + 1)...num_counters).each do |r|
            if augmented[r][col] != 0
                factor = augmented[r][col] / augmented[pivot_row][col]
                (col..num_buttons).each do |c|
                    augmented[r][c] -= factor * augmented[pivot_row][c]
                end
            end
        end

        pivot_row += 1
    end

    # Back substitution - encontra solução
    solution = Array.new(num_buttons, Rational(0))

    (num_counters - 1).downto(0) do |row|
        # Encontra primeira coluna não-zero nesta linha
        pivot_col = (0...num_buttons).find { |c| augmented[row][c] != 0 }
        next if pivot_col.nil?

        sum = Rational(0)
        ((pivot_col + 1)...num_buttons).each do |c|
            sum += augmented[row][c] * solution[c]
        end

        solution[pivot_col] = (augmented[row][num_buttons] - sum) / augmented[row][pivot_col]
    end

    # Retorna soma (todas devem ser inteiros não-negativos)
    solution.map { |x| x.to_i }.sum
end

input = File.readlines(ARGV[0] || INPUT_FILE, chomp: true)

machine_PATTERN = /(?<lights>\[.*?\])\s*(?<buttons>.*?)\s*(?<joltage>\{.*?\})/

machines = input.map do |line|
    match_data = line.match(machine_PATTERN)
    {
        buttons: match_data["buttons"],
        joltage: match_data["joltage"]
    }
end

machines.map! { |machine| parse_machine(machine) }

machines_count = machines.map do |machine|
    solve_joltage(machine[:buttons], machine[:joltage])
end

puts machines_count.sum


