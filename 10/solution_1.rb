input = File.read('input.txt').split(/\n/).map(&:to_i).sort
input = [0] + input + [input.max + 3]
diffs = (1..input.count - 1).map { |i| input[i] - input[i - 1] }
diffs_1 = diffs.select { |d| d == 1 }
diffs_3 = diffs.select { |d| d == 3 }
puts diffs_1.count * diffs_3.count
