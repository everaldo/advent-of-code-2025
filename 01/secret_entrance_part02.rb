#! /bin/env ruby

input = File.read('./input.txt')

initial = 50
dial = initial
pointing_at_0 = 0

input.split("\n").each do |line|
    direction, rotations = line[0], line[1..-1].to_i
    if direction == 'L'
        if dial - rotations.modulo(100) < 0
            pointing_at_0 += 1 unless dial.zero?
            dial = 100 - (dial - rotations.modulo(100)).abs
        else
            dial = dial - rotations.modulo(100)
        end
    else
        if dial + rotations.modulo(100) > 100
            dial = (dial + rotations.modulo(100)).modulo(100)
            pointing_at_0 += 1
        else
            dial = (dial + rotations.modulo(100)).modulo(100)
        end
    end
    pointing_at_0 += 1 if dial.zero?
    pointing_at_0 += rotations.div(100)
    #puts("dial= #{dial} rotations= #{rotations} pointing= #{pointing_at_0}")
end

puts(pointing_at_0)
