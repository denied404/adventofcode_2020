def valid?(password, min, max, letter)
  count = 0
  count += 1 if password.chars[min - 1] == letter
  count += 1 if password.chars[max - 1] == letter
  count == 1
end

raw_input = File.read('input.txt').split("\n")
input = raw_input.map do |e|
  e_split = e.split(' ')
  range_split = e_split[0].split('-')
  range = { min: range_split[0].to_i, max: range_split[1].to_i }
  letter = e_split[1].split(':')[0]
  { min: range[:min], max: range[:max], letter: letter, password: e_split[2] }
end

puts input.select { |i| valid?(i[:password], i[:min], i[:max], i[:letter]) }.count
