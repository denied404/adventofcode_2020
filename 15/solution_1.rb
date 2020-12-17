start = File.read('input.txt').gsub("\n", '').split(',').map(&:to_i)
game = {}
game_arr = []
iter = 0

def push_number(num, iter, game, game_arr)
  game_arr.push(num)
  if game.key?(num)
    game[num][:prev] = game[num][:curr]
    game[num][:curr] = iter
  else
    game[num] = { curr: iter, prev: nil }
  end
end

# Warming up
start.each_with_index do |n, i|
  game[n] = { curr: i + 1, prev: nil }
  game_arr.push(n)
  iter += 1
end

while iter < 30000000
  iter += 1
  if game[game_arr.last][:prev].nil?
    push_number(0, iter, game, game_arr)
  else
    push_number(game[game_arr.last][:curr] - game[game_arr.last][:prev], iter, game, game_arr)
  end
end

puts iter
puts game_arr.last(6)
