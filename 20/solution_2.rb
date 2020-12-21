tiles = []

input = File.read('input.txt')
input.split("\n\n").each do |i|
  lines = i.split("\n")
  id = lines[0][/\d+/].to_i
  tile = lines[1..lines.count - 1].map { |l| l.chars }
  tiles.push(id: id, tile: tile)
end

def generate_edges(tile)
  edges = []
  edges.push(tile[:tile].first.join)
  edges.push(tile[:tile].last.join)
  edges.push(tile[:tile].map { |t| t.first }.join)
  edges.push(tile[:tile].map { |t| t.last}.join)
  edges
end

def edges_matched(index, tiles)
  tile_edges = generate_edges(tiles[index])
  tile_edges += tile_edges.map(&:reverse)
  other_edges = ((0..tiles.count - 1).to_a - [index]).map do |t|
    generate_edges(tiles[t]) + generate_edges(tiles[t]).map(&:reverse)
  end.flatten
  tile_edges.select { |t| other_edges.include?(t) }.count
end

puts (0..tiles.count - 1).select { |i| edges_matched(i, tiles) == 4 }
                         .map { |i| tiles[i][:id] }
                         .reduce(&:*)

