DIRECTIONS = %w(e se sw w nw ne).freeze

COORDS = {
  'e'  => { op: :+, idx: 0 },
  'w'  => { op: :-, idx: 0 },
  'se' => { op: :+, idx: 1 },
  'nw' => { op: :-, idx: 1 },
  'ne' => { op: :+, idx: 2 },
  'sw' => { op: :-, idx: 2 }
}.freeze

def flip(color)
  color == 'white' ? 'black' : 'white'
end

def recalc_pos(pos)
  if pos[1] * pos[2] > 0
    # puts "Recalced #{pos.join(',')}..."
    min = pos[1..2].map(&:abs).min
    p = pos[1]
    pos[1] -= min * (p / p.abs)
    pos[2] -= min * (p / p.abs)
    pos[0] += min * (p / p.abs)
    # puts "...to #{pos.join(',')}"
  end
  if pos[0] * pos[1] < 0
    p = pos[0]
    min = pos[0..1].map(&:abs).min
    pos[0] -= min * (p / p.abs)
    pos[1] += min * (p / p.abs)
    pos[2] += min * (p / p.abs)
  end
  if pos[0] * pos[2] < 0
    p = pos[0]
    min = [pos[0], pos[2]].map(&:abs).min
    pos[0] -= min * (p / p.abs)
    pos[2] += min * (p / p.abs)
    pos[1] += min * (p / p.abs)
  end
  pos
end

input = File.read('input.txt')
            .split("\n")
            .map { |s| s.scan(/(#{DIRECTIONS.join('|')})/).map(&:first) }

tiles = Hash.new('white')

input.each do |path|
  pos = [0, 0, 0]
  # puts "path #{path.join(',')}"
  path.each do |move|
    coord = COORDS[move]
    # puts "move: #{move}, old_pos: #{pos.join(',')}"
    pos[coord[:idx]] = pos[coord[:idx]].send(coord[:op], 1)
    pos = recalc_pos(pos)
    # puts "new_pos: #{pos.join(',')}"
  end
  tiles[pos] = flip(tiles[pos])
  # puts "(#{pos.join(',')}): #{tiles[pos]}"
end

puts tiles.values.select { |v| v == 'black' }.count
