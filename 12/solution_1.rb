DIRECTIONS = %w(E S W N).freeze
ctx = { i:  0 }
route = Hash.new(0)

def process(entry, route, directions, ctx)
  case entry[:cmd]
  when 'F'
    route[directions[ctx[:i]]] += entry[:val]
  when 'R'
    rotate(entry[:val], ctx)
  when 'L'
    rotate(-1 * entry[:val], ctx)
  when *directions
    route[entry[:cmd]] += entry[:val]
  end
end

def rotate(deg, ctx)
  ctx[:i] = (ctx[:i] + (deg / 90)) % 4
end

input = File.read('input.txt')
            .split(/\n/)
            .map { |x| { cmd: x[0], val: x[1..-1].to_i } }

input.each { |cmd| process(cmd, route, DIRECTIONS, ctx) }

puts route['S'] - route['N'] + route['E'] - route['W']
