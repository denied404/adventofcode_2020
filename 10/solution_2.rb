input = File.read('input.txt').split(/\n/).map(&:to_i).sort
input = [0] + input + [input.max + 3]

def distinct_connections(input, idx = 0, acc = { 0 => 1 })
  return acc[input.count - 1] unless idx <= input.count - 1
  j = idx + 1
  while j < input.count && input[j] <= input[idx] + 3
    acc[j] = (acc.key?(j) ? acc[j] : 0) + acc[idx]
    j += 1
  end
  distinct_connections(input, idx + 1, acc)
end

puts distinct_connections(input)
