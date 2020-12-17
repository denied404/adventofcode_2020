DIRECTIONS = { 'E' => 0, 'S' => 1, 'W' => 2, 'N' => 3 }.freeze
waypoint = Hash.new(0)
waypoint['E'] = 10
waypoint['N'] = 1
route = Hash.new(0)

def process(entry, route, directions, waypoint)
  case entry[:cmd]
  when 'F'
    move_forward(entry[:val], route, waypoint)
  when 'R'
    rotate_waypoint(entry[:val], waypoint, directions)
  when 'L'
    rotate_waypoint(-1 * entry[:val], waypoint, directions)
  when *directions.keys
    waypoint[entry[:cmd]] += entry[:val]
  end
end

def move_forward(val, route, waypoint)
  waypoint.keys.each { |d| route[d] += waypoint[d].to_i * val }
end

def rotate_waypoint(deg, waypoint, directions)
  rotated = Hash.new(0)
  waypoint.keys.each do |d|
    rotated[directions.keys[(directions[d] + (deg / 90)) % 4]] = waypoint[d]
  end
  waypoint.clear
  rotated.keys.each { |k| waypoint[k] = rotated[k] }
end

input = File.read('input.txt')
            .split(/\n/)
            .map { |x| { cmd: x[0], val: x[1..-1].to_i } }

input.each { |cmd| process(cmd, route, DIRECTIONS, waypoint) }

puts route['S'] - route['N'] + route['E'] - route['W']
