cups = File.read('input.txt').gsub("\n",'').chars.map(&:to_i)

def move(cups, move_num)
  puts "-- move #{move_num} --"
  pick = (1..3).to_a.map { |i| cups[i % cups.count] }
  dest = cups[0] - 1
  if pick.include? dest
    dest -= 1 while pick.include? dest
  end
  dest = (cups - pick).max unless cups.include? dest
  puts "cups: #{cups.join(', ')}"
  puts "pick up: #{pick.join(', ')}"
  puts "destination: #{dest}"
  puts "\n"
  cups[4..cups.index(dest)] + pick + cups[cups.index(dest) + 1..-1] + [cups[0]]
end

(1..100).each do |m|
  cups = move(cups, m)
end

puts "-- final --"
puts "cups: #{cups.join(', ')}"
