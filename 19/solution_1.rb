def rule_words(rule, rules)
  return nil unless rules.key? rule
  return [rules[rule][:val]] if rules[rule][:leaf]
  res = []
  rule_words(rules[rule][:first][0], rules).each do |f|
    (rule_words(rules[rule][:first][1], rules) || ['']).each do |s|
      res.push("#{f}#{s}")
    end
  end
  unless rules[rule][:second].nil?
    rule_words(rules[rule][:second][0], rules).each do |f|
      (rule_words(rules[rule][:second][1], rules) || ['']).each do |s|
        res.push("#{f}#{s}")
      end
    end
  end
  res
end

input = File.read('input_1.txt').split("\n\n")

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
  puts "#{s}: #{comb.include? s}"
  sum += 1 if comb.include? s
end

puts sum
