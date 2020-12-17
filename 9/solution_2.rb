PREAMBLE_LENGTH = 25

def valid?(number, input, idx, offset)
  (idx - offset..idx - 1).each do |i|
    (i + 1..idx).each do |j|
      return true if input[i] + input[j] == number
    end
  end
  false
end

def contiguous_sum(number, input)
  (0..input.count - 2).each do |i|
    stack = { i => input[i] }
    j = i
    while j <= input.count - 1
      j += 1
      stack[j] = input[j]
      return stack if stack.values.sum == number
      break if stack.values.sum > number
    end
  end
end

input = File.read('input.txt').split(/\n/).map(&:to_i)
non_valid_number = -1

(PREAMBLE_LENGTH..input.count - 1).each do |i|
  is_valid = valid?(input[i], input, i, PREAMBLE_LENGTH)
  unless is_valid
    non_valid_number = input[i]
    break
  end
end

sum_hash = contiguous_sum(non_valid_number, input)
puts "Contiguous sum for #{non_valid_number} is #{sum_hash}"

answer = sum_hash.values.min + sum_hash.values.max
puts "Answer is #{answer}"
