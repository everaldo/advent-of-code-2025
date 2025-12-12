#! /bin/env ruby

require 'byebug'

INPUT_FILE = "input_teste.txt"

INDICATOR_LIGHT_ON = "#"
INDICATOR_LIGHT_OFF= "."


def state_to_i(state)
    state.each_with_index.reduce(0) { |memo, e| e[0] ? memo + 2.pow(e[1]) : memo  }
end

def next_state(state, button)
    button.reduce(state) do |state, light|
        state ^ (1 << light)
    end
end



def count_buttons(initial_state, finish_state, buttons, visited)
    return 0 if initial_state == finish_state

    visited = Set.new([initial_state])
    queue = [initial_state]
    depth = 0

    while !queue.empty?
        depth += 1
        next_queue = []

        queue.each do |state|
            buttons.each do |button|
                candidate = next_state(state, button)

                return depth if candidate == finish_state

                unless visited.include?(candidate)
                    visited.add(candidate)
                    next_queue << candidate
                end
            end
        end

        queue = next_queue
    end

    Float::INFINITY
end


def parse_machine(machine_hash)
    lights = machine_hash[:lights].split("").slice(1...-1).map { |light| light == INDICATOR_LIGHT_ON ? true : false }
    buttons = machine_hash[:buttons].split(" ").map! { |button_str| button_str.slice(1...-1).split(",").map(&:to_i) }
    {
        lights: lights,
        buttons: buttons
    }
end



input = File.readlines(ARGV[0] || INPUT_FILE, chomp: true)


machine_PATTERN = /(?<lights>\[.*?\])\s*(?<buttons>.*?)\s*(?<joltage>\{.*?\})/


machines = input.map do |line|
    match_data = line.match(machine_PATTERN)
    {
        lights: match_data["lights"],
        buttons: match_data["buttons"],
        joltage: match_data["joltage"]
    }
end

machines.map! { |machine| parse_machine(machine)}


machines_count = machines.map do |machine|
    initial_state = 0
    finish_state = state_to_i(machine[:lights])
    buttons = machine[:buttons]
    count_buttons(initial_state, finish_state, buttons, [initial_state])
end

puts machines_count.sum


