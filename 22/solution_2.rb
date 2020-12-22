def score(cards)
  cards.each_with_index
       .map { |c, i| c * (cards.count - i) }
       .reduce(&:+)
end

def game(p1, p2, round = 1, game = 1, acc = {})
  while p2.count > 0 && p1.count > 0

    if acc.key?(:p1) && acc[:p1].key?(p1) && acc.key?(:p2) && acc[:p2].key?(p2) && (acc[:p1][p1] & acc[:p2][p2]).count > 0
      return 1
    end

    acc[:p1] ||= {}
    acc[:p2] ||= {}
    acc[:p1][p1] ||= []
    acc[:p2][p2] ||= []
    acc[:p1][p1].push(round)
    acc[:p2][p2].push(round)

    c1 = p1.shift
    c2 = p2.shift

    win = if p1.count >= c1 && p2.count >= c2
            game(p1[0..c1 - 1], p2[0..c2 - 1], 1, game + 1, {})
          else
            c2 > c1 ? 2 : 1
          end
    if win == 1
      p1.push(c1).push(c2)
    else
      p2.push(c2).push(c1)
    end
    round += 1
  end

  return 1 if p2.count.zero?
  return 2 if p1.count.zero?
end

input = File.read('input.txt').split("\n\n")

p1 = input[0].split("\n")[1..-1].map(&:to_i)
p2 = input[1].split("\n")[1..-1].map(&:to_i)

win = game(p1, p2)
puts win == 1 ? score(p1) : score(p2)
