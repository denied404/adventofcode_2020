def score(cards)
  cards.each_with_index
       .map { |c, i| c * (cards.count - i) }
       .reduce(&:+)
end

input = File.read('input.txt').split("\n\n")

p1 = input[0].split("\n")[1..-1].map(&:to_i)
p2 = input[1].split("\n")[1..-1].map(&:to_i)

iter = 0
while p1.count !=0 && p2.count != 0
  iter += 1 
  c1 = p1.shift
  c2 = p2.shift
  if c1 > c2
    p1.push(c1).push(c2)
  else
    p2.push(c2).push(c1)
  end
end

puts p1.count == 0 ? score(p2) : score(p1)
