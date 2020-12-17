PREAMBLE_LENGTH = 25

def valid?(number, input, idx, offset)
  (idx - offset..idx - 1).each do |i|
    (i + 1..idx).each do |j|
      return true if input[i] + input[j] == number
    end
  end
  false
end

input = File.read('input.txt').split(/\n/).map(&:to_i)

(PREAMBLE_LENGTH..input.count - 1).each do |i|
  is_valid = valid?(input[i], input, i, PREAMBLE_LENGTH)
  puts "#{i} #{input[i]} #{is_valid}" unless is_valid
end
