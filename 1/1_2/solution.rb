input = File.read('input.txt').split.map(&:to_i)
(0..input.length - 1).each do |i|
  (i..input.length - 1).each do |j|
    (j..input.length - 1).each do |k|
      if input[i] + input[j] + input[k] == 2020
        puts input[i], input[j], input[k], input[i] * input[j] * input[k]
        exit 0
      end
    end
  end
end
