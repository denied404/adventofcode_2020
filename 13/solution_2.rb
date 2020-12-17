buses = File.read('input.txt').split(/\n/)[1]
        .split(',')
        .each_with_index.map { |v, i| { id: v.to_i, idx: i } }
        .select { |x| x[:id] != 0 }

mult = (100_000_000_000_000 / buses[0][:id]) - 1
mult_inc = 1
puts "Start with mult #{mult} at timing #{mult * buses[0][:id]}"
loop do
  mult += mult_inc
  stop_flag = true
  (1..buses.count - 1).each do |i|
    if (buses[0][:id] * mult + buses[i][:idx]) % buses[i][:id] != 0
      stop_flag = false
      break
    end
    mult_inc = buses[0..i].map { |x| x[:id] }.reduce(1, :lcm) / buses[0][:id]
  end
  break if stop_flag
end

puts "Timestamp is #{mult * buses[0][:id]}"
