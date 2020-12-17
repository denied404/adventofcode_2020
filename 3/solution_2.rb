TREE = '#'.freeze

def tree?(sym)
  sym == TREE
end

map = File.read('input.txt').split("\n").map(&:chars)

slopes = [
  { right: 1, down: 1 },
  { right: 3, down: 1 },
  { right: 5, down: 1 },
  { right: 7, down: 1 },
  { right: 1, down: 2 }
]

tree_counts = []

slopes.each do |s|
  # Starting point
  x = 0
  y = 0
  path = []

  while y <= map.length - 1
    x = (x + s[:right]) % map[y].length
    y += s[:down]
    path.push(map[y][x]) if y <= map.length - 1
  end

  tree_counts.push(path.select { |c| tree?(c) }.length)
  puts tree_counts.join(', ')
end

puts tree_counts.reduce(:*)
