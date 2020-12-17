EMPTY_SEAT = 'L'.freeze
OCCUPIED_SEAT = '#'.freeze

seat_map = File.read('input.txt').split(/\n/).map { |r| r.chars }

def round(map)
  new_map = Marshal.load(Marshal.dump(map))
  (0..new_map.count - 1).each do |i|
    (0..new_map[i].count - 1).each do |j|
      change_state(i, j, new_map)
    end
  end
  new_map
end

def change_state(i, j, map)
  case map[i][j]
  when EMPTY_SEAT
    empty_seat_rule(i, j, map)
  when OCCUPIED_SEAT
    occupied_seat_rule(i, j, map)
  end
end

def occupied_seat_rule(i, j, map)
  min_i = [i - 1, 0].max
  max_i = [i + 1, map.count - 1].min
  min_j = [j - 1, 0].max
  max_j = [j + 1, map[i].count - 1].min
  occupied_count = 0
  (min_i..max_i).each do |x|
    (min_j..max_j).each do |y|
      next if x == i && y == j
      occupied_count += 1 if map[x][y] == OCCUPIED_SEAT
    end
  end
  map[i][j] = EMPTY_SEAT if occupied_count >= 4
end

def empty_seat_rule(i, j, map)
  min_i = [i - 1, 0].max
  max_i = [i + 1, map.count - 1].min
  min_j = [j - 1, 0].max
  max_j = [j + 1, map[i].count - 1].min
  (min_i..max_i).each do |x|
    (min_j..max_j).each do |y|
      next if x == i && y == j
      return if map[x][y] == OCCUPIED_SEAT
    end
  end
  map[i][j] = OCCUPIED_SEAT
end


old_map = Marshal.load(Marshal.dump(seat_map))
iterations = 0
loop do
  new_map = round(old_map)
  iterations += 1

  if new_map == old_map
    new_map.each { |m| puts m.join('') }
    puts new_map.map { |m| m.select { |x| x == OCCUPIED_SEAT }.count }.sum
    break
  end
  old_map = Marshal.load(Marshal.dump(new_map))
end
