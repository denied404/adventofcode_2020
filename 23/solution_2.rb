MAX_CUP = 1_000_000.freeze

cups = File.read('input.txt').gsub("\n",'').chars.map(&:to_i)
(cups.max + 1..MAX_CUP).each { |n| cups.push(n) }

def move(cups, move_num)
  # puts "-- move #{move_num} --"
  pick = (1..3).to_a.map { |i| cups[i % cups.count] }
  dest = cups[0] - 1
  if pick.include? dest
    dest -= 1 while pick.include? dest
  end
  dest = ((0..3).to_a.map { |x| MAX_CUP - x } - pick).max unless dest > 0
  d_i = cups.index(dest)
  cups[4..d_i] + pick + cups[d_i + 1..-1] + [cups[0]]
end

# i1 = cups.index(1)
# c1 = cups[i1]
# c2 = cups[(i1 + 1) % MAX_CUP]
# c3 = cups[(i1 + 2) % MAX_CUP]

(1..MAX_CUP).each do |m|
  cups = move(cups, m)
  puts "#{m}" if m % 1000 == 0
  # i1 = cups.index(1)
  # if [c2, c3] != [cups[(i1 + 1) % MAX_CUP], cups[(i1 + 2) % MAX_CUP]]
  #   puts "m: #{m}, #{cups[i1]}, #{cups[(i1 + 1) % MAX_CUP]}, #{cups[(i1 + 2) % MAX_CUP]}"
  # end
  # c1 = cups[i1]
  # c2 = cups[(i1 + 1) % MAX_CUP]
  # c3 = cups[(i1 + 2) % MAX_CUP]
end
