TREE = '#'.freeze

def tree?(sym)
  sym == TREE
end

map = File.read('input.txt').split("\n").map(&:chars)

# Starting point
x = 0
y = 0
path = []

while y <= map.length - 1
  x = (x + 3) % map[y].length
  y += 1
  path.push(map[y][x]) if y <= map.length - 1
end

puts path.select { |c| tree?(c) }.length
