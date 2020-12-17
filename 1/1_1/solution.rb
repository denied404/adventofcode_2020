input = File.read('input.txt').split.map(&:to_i)
(0..input.length - 1).each do |i|
  (i..input.length - 1).each do |j|
    if input[i] + input[j] == 2020
      puts input[i], input[j], input[i] * input[j]
      exit 0
    end
  end
end
