input = File.read('input.txt').split(/\n/)

ETA = input[0].to_i
BUS = input[1].split(',').select { |x| x != 'x' }.map(&:to_i)
wait_time = nil
bus_id = nil

BUS.each do |b|
  mult = 0
  mult += 1 while mult * b < ETA
  if wait_time.nil? || wait_time > (mult * b - ETA)
    wait_time = mult * b - ETA
    bus_id = b
  end
end

puts ETA
puts "#{wait_time} * #{bus_id} = #{wait_time * bus_id}"
