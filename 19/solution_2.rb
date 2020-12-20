# DISCLAIMER: OK, this is 100% ADOPTED FOR THE GIVEN INPUT CASES SOLUTION
# WHICH TAKES INTO A COUNT THAT BOTH RULE 42 AND RULE 31 PRODUCES LISTS OF
# 8-CHARS WORDS 
# I am not proud of this, but it solves the daily story. Also, the story 
# explicitly says:
#
# Remember, you only need to handle the rules you have; building a solution
# that could handle any hypothetical combination of rules would be
# significantly more difficult.
#
# So I guess I'm fine with this one /shrug/

# This one gives all possible list of match combinations for a given rule
def rule_words(rule, rules)
  return [rules[rule][:val]] if rules[rule][:leaf]
  res = rules[rule][:first].map { |r| rule_words(r, rules) }
                           .reduce([nil]) { |a, e| a.product(e).map(&:join) }
  # No :second option looping here for 8 and 11 cycle loops, we'll do looping later
  return res if ['8', '11'].include? rule
  unless rules[rule][:second].nil?
    res += rules[rule][:second].map { |r| rule_words(r, rules) }
                               .reduce([nil]) { |a, e| a.product(e).map(&:join) }
  end
  res
end

# Filling input into variables
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

# Our zero rule contain 8 and 11 rules, each of them in their turn is a cyclic rule
# based on rule 42 and rule 31. So we'll do some shenanigans with all combinations
# which match those two rules
comb_42 = rule_words('42', rules)
comb_31 = rule_words('31', rules)

# We generate all possible combinations which would match all strings
# up to max-len string from input.
# Rule 8 basically is any of [1..infinite] number of
# rule 42: 42, 42, 42,...etc
# Rule 11 is any of [1..infinite] number of 42, 31 nested one into another like this:
# (42, 31), (42, 42, 31, 31), etc. 
# So minimum possible set of combinations for rule 0 is:
# 42, 42, 31 
# We're going to generate all possible cases for 8 and 11 rule combinations from minimal
# possible up to max-len-string 
possible_cases = []
(3..strings.map(&:length).max).each do |i|
  (1..(i - 1) / 2).each do |j|
    possible_cases.push([42] * (i - j) + [31] * j)
  end
end

# Check a given word aka input string for all possible cases of 42, 31 combinations
# which would match zero rule
def word_check(word, c42, c31, cases)
  clen = 8
  return false unless cases.map { |c| clen * c.count }.uniq.include? word.length
  cases.select { |c| clen * c.count == word.length }.each do |cs|
    match = true
    cs.each_with_index do |c, i|
      arr = c == 42 ? c42 : c31
      match = false unless arr.include? word[i * clen..i * clen - 1 + clen]
    end
    return true if match
  end
  return false
end

# Answer
puts strings.select { |s| word_check(s, comb_42, comb_31, possible_cases) }.count
