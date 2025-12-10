#!/usr/bin/env ruby

INPUT_FILE = "./input.txt"
require 'set'

# Verifica se ponto está dentro do polígono (ray casting)
def point_in_polygon?(point, polygon)
  px, py = point
  inside = false

  polygon.each_cons(2) do |(x1, y1), (x2, y2)|
    if (y1 > py) != (y2 > py)
      x_intersect = x1 + (py - y1).to_f * (x2 - x1) / (y2 - y1)
      inside = !inside if px < x_intersect
    end
  end

  inside
end

# Verifica se ponto está na borda do polígono
def point_on_edge?(point, polygon)
  px, py = point

  polygon.each_cons(2) do |(x1, y1), (x2, y2)|
    if y1 == y2  # horizontal
      min_x, max_x = [x1, x2].minmax
      return true if py == y1 && px >= min_x && px <= max_x
    elsif x1 == x2  # vertical
      min_y, max_y = [y1, y2].minmax
      return true if px == x1 && py >= min_y && py <= max_y
    end
  end

  false
end

# Verifica se dois segmentos se intersectam (não apenas tocam)
def segments_cross?(seg1, seg2)
  (x1, y1), (x2, y2) = seg1
  (x3, y3), (x4, y4) = seg2

  # Calcula orientações
  d1 = direction(x3, y3, x4, y4, x1, y1)
  d2 = direction(x3, y3, x4, y4, x2, y2)
  d3 = direction(x1, y1, x2, y2, x3, y3)
  d4 = direction(x1, y1, x2, y2, x4, y4)

  # Se cruzam propriamente
  if ((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
     ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))
    return true
  end

  false
end

def direction(x1, y1, x2, y2, x3, y3)
  (x3 - x1) * (y2 - y1) - (y3 - y1) * (x2 - x1)
end

# Verifica se retângulo está completamente contido no polígono
def rectangle_in_polygon?(rect, polygon)
  min_x, max_x = rect[:min_x], rect[:max_x]
  min_y, max_y = rect[:min_y], rect[:max_y]

  # 1. Verifica se os 4 cantos estão dentro ou na borda
  corners = [
    [min_x, min_y],
    [max_x, min_y],
    [min_x, max_y],
    [max_x, max_y]
  ]

  corners.each do |corner|
    return false unless point_in_polygon?(corner, polygon) || point_on_edge?(corner, polygon)
  end

  # 2. Verifica se as bordas do retângulo não cruzam as bordas do polígono
  rect_edges = [
    [[min_x, min_y], [max_x, min_y]],  # topo
    [[max_x, min_y], [max_x, max_y]],  # direita
    [[max_x, max_y], [min_x, max_y]],  # baixo
    [[min_x, max_y], [min_x, min_y]]   # esquerda
  ]

  polygon.each_cons(2) do |p1, p2|
    poly_edge = [p1, p2]
    rect_edges.each do |rect_edge|
      return false if segments_cross?(rect_edge, poly_edge)
    end
  end

  true
end

# === MAIN ===

tiles = File.readlines(ARGV[0] || INPUT_FILE, chomp: true).map do |line|
  line.split(",").map(&:to_i)
end

closed_polygon = tiles + [tiles.first]

# Gera retângulos e ordena do MAIOR para MENOR
rectangles = tiles.combination(2).map do |p0, p1|
  x0, y0 = p0
  x1, y1 = p1

  min_x, max_x = [x0, x1].minmax
  min_y, max_y = [y0, y1].minmax

  area = (max_x - min_x + 1) * (max_y - min_y + 1)

  { area: area, min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y }
end

rectangles.sort_by! { |r| -r[:area] }

max_area = 0

rectangles.each do |rect|
  # OTIMIZAÇÃO: pula retângulos menores que o máximo encontrado
  break if rect[:area] <= max_area

  if rectangle_in_polygon?(rect, closed_polygon)
    max_area = rect[:area]
  end
end

puts max_area
