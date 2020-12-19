def rule_words(rule, rules, loop_lim = { '8' => 0, '11' => 0 })
  # All looping cases with more depth will be cut
  loop_limit = 2
  return nil unless rules.key? rule
  return [rules[rule][:val]] if rules[rule][:leaf]
  res = []
  loop_lim[rule] += 1 if loop_lim.keys.include? rule
  rule_words(rules[rule][:first][0], rules, loop_lim).each do |f|
    (rule_words(rules[rule][:first][1], rules, loop_lim) || ['']).each do |s|
      (rule_words(rules[rule][:first][2], rules, loop_lim) || ['']).each do |t|
        res.push("#{f}#{s}#{t}")
      end
    end
  end
  return res if loop_lim.key?(rule) && loop_lim[rule] > loop_limit
  unless rules[rule][:second].nil?
    rule_words(rules[rule][:second][0], rules, loop_lim).each do |f|
      (rule_words(rules[rule][:second][1], rules, loop_lim) || ['']).each do |s|
        (rule_words(rules[rule][:second][2], rules, loop_lim) || ['']).each do |t|
          res.push("#{f}#{s}#{t}")
        end
      end
    end
  end
  res
end

input = File.read('input_2.txt').split("\n\n")

strings = input[1].split("\n")
rules = {}

input[0].split("\n").map { |i| i.split(': ') }.each do |inp|
  key = inp[0]
  leaf = %w(a b).include?(inp[1].delete('"')) ? true : false
  if leaf
    rules[key] = { leaf: leaf, val: inp[1].delete('"') }
  else
    if inp[1].include?('|')
      first = inp[1].split(' | ')[0].split(' ')
      second = inp[1].split(' | ')[1].split(' ')
    else
      first = inp[1].split(' ')
      second = nil
    end
    rules[key] = {
      leaf: leaf,
      first: first,
      second: second
    }
  end
end

comb = rule_words('0', rules)
sum = 0
strings.each do |s|
  # puts "#{s}: #{comb.include? s}"
  sum += 1 if comb.include? s
end

puts "Combinations: #{comb.count}"
puts "Strings match rule 0: #{sum}"
