# require 'byebug'

def contain?(bag_color, check_color, colors_hash)
  return false unless colors_hash[bag_color] != {}
  return true if colors_hash[bag_color].keys.include? check_color
  colors_hash[bag_color].keys.map do |inner_bag_color|
    contain?(inner_bag_color, check_color, colors_hash)
  end.any?
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
    colors_hash[color][s[1]] = s[0]
  end
end

check_array = colors_hash.keys.map { |bag_color| contain?(bag_color, 'shiny gold', colors_hash) }
puts check_array.count
puts check_array.select { |x| x }.count
