cube = {}
input = File.read('input.txt').split("\n").map(&:chars)
input.each_with_index do |arr, x|
  arr.each_with_index do |v, y|
    cube[x] ||= {}
    cube[x][y] ||= {}
    cube[x][y][0] = v
  end
end

# Ranges in which we check states on each iteration
range = { x: { min: -1, max: input.count },
          y: { min: -1, max: input[0].count },
          z: { min: -1, max: 1 } }

def puts_zslice(cube, z = 0)
  cube.keys.each do |x|
    puts cube[x].keys.map { |y| cube[x][y][z] }.join
  end
end

def iteration(current_cube, range)
  new_cube = Marshal.load(Marshal.dump(current_cube))
  (range[:x][:min]..range[:x][:max]).each do |x|
    (range[:y][:min]..range[:y][:max]).each do |y|
      (range[:z][:min]..range[:z][:max]).each do |z|
        new_cube[x] ||= {}
        new_cube[x][y] ||= {}
        new_cube[x][y][z] = change_state(x, y, z, current_cube)
      end
    end
  end
  new_cube
end

def active?(x, y, z, cube)
  cube[x] && cube[x][y] && cube[x][y][z] == '#'
end

def change_state(x, y, z, cube)
  sum_active = 0
  (x - 1..x + 1).each do |i|
    (y - 1..y + 1).each do |j|
      (z - 1..z + 1).each do |k|
        unless i == x && j == y && k == z
          sum_active += 1 if active?(i, j, k, cube)
        end
      end
    end
  end
  if active?(x, y, z, cube)
    return sum_active == 2 || sum_active == 3 ? '#' : '.'
  else
    return sum_active == 3 ? '#' : '.'
  end
end

puts "Before iterations"
puts_zslice(cube)
(1..6).each do |iter|
  cube = iteration(cube, range)
  puts "Iteration #{iter}, z=0"
  puts_zslice(cube)
  # Extend check ranges by 1 for each dimension
  range.keys.each do |dim|
    range[dim][:min] -= 1
    range[dim][:max] += 1
  end
end

sum_active = 0
cube.keys.each do |x|
  cube[x].keys.each do |y|
    cube[x][y].keys.each do |z|
      sum_active += 1 if cube[x][y][z] == '#'
    end
  end
end

puts sum_active
