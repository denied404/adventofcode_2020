EMPTY_SEAT = 'L'.freeze
OCCUPIED_SEAT = '#'.freeze

seat_map = File.read('input.txt').split(/\n/).map { |r| r.chars }

def empty_occupied(arr)
  arr.select { |s| empty?(s) || occupied?(s) }
end

def surrounding(i, j, map)
  map_j_max = map[i].count - 1
  map_i_max = map.count - 1
  [
    # left
    (j == 0) ? nil : empty_occupied(map[i][0..j - 1]).last,
    # right
    (j == map_j_max) ? nil : empty_occupied(map[i][j + 1..map_j_max]).first,
    # up
    (i == 0) ? nil : empty_occupied(map[0..i - 1].map { |s| s[j] }).last,
    # down
    (i == map_i_max) ? nil : empty_occupied(map[i + 1..map_i_max].map { |s| s[j] }).first,
    # up left diag
    (i == 0 || j == 0) ? nil : empty_occupied((1..[i, j].min).map { |x| map[i - x][j - x] }).first,
    # down right diag
    (i == map_i_max || j == map_j_max) ? nil : empty_occupied((1..[map_i_max - i, map_j_max - j].min).map { |x| map[i + x][j + x] }).first,
    # down left diag
    (i == map_i_max || j == 0) ? nil : empty_occupied((1..[map_i_max - i, j].min).map { |x| map[i + x][j - x] }).first,
    # up right diag
    (i == 0 || j == map_j_max) ? nil : empty_occupied((1..[i, map_j_max - j].min).map { |x| map[i - x][j + x] }).first
  ]
end

def empty?(seat)
  seat == EMPTY_SEAT
end

def occupied?(seat)
  seat == OCCUPIED_SEAT
end

def round(map)
  new_map = Marshal.load(Marshal.dump(map))
  (0..new_map.count - 1).each do |i|
    (0..new_map[i].count - 1).each do |j|
      change_state(i, j, new_map, map)
    end
  end
  new_map
end

def change_state(i, j, map, old_map)
  if empty?(map[i][j])
    empty_seat_rule(i, j, map, old_map)
  elsif occupied?(map[i][j])
    occupied_seat_rule(i, j, map, old_map)
  end
end

def occupied_seat_rule(i, j, map, old_map)
  if surrounding(i, j, old_map).select { |x| occupied?(x) }.count >= 5
    map[i][j] = EMPTY_SEAT
  end
end

def empty_seat_rule(i, j, map, old_map)
  if surrounding(i, j, old_map).select { |x| occupied?(x) }.count == 0
    map[i][j] = OCCUPIED_SEAT
  end
end


old_map = Marshal.load(Marshal.dump(seat_map))
iterations = 0
loop do
  new_map = round(old_map)
  iterations += 1
  puts iterations
  if new_map == old_map
    new_map.each { |m| puts m.join('') }
    puts new_map.map { |m| m.select { |x| occupied?(x) }.count }.sum
    break
  end
  old_map = Marshal.load(Marshal.dump(new_map))
end
