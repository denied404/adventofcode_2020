def bags_count(color, colors_hash, stack = [0], multiplier = 1)
  return stack.last if colors_hash[color] == {}
  multiplier + colors_hash[color].keys.map do |nested_color|
    new_multiplier = multiplier * colors_hash[color][nested_color]
    bags_count(nested_color,
               colors_hash, stack + [new_multiplier], new_multiplier)
  end.sum
end

colors_hash = {}

raw_input = File.read('input.txt').split("\n")

raw_input.map do |str_rule|
  color = str_rule.scan(/(.*) bag. contain/).first.first
  contained_colors_str = str_rule.split('contain ')[1]
  colors_hash[color] = {}
  next unless contained_colors_str != 'no other bags.'
  contained_colors_str.split(', ').each do |contained_color|
    s = contained_color.scan(/(\d*) (.*) bag/).first
    colors_hash[color][s[1]] = s[0].to_i
  end
end

puts bags_count('shiny gold', colors_hash) - 1
