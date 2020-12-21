ing_stat = {}
all_stat = {}

# Read input
input = File.read('input.txt').split("\n").map do |m|
  if m.include?('(')
    spl = m.split('(')
    ingredients = spl[0].split(' ').compact
    allergens = spl[1].gsub(')', '')
                      .split(' ')
                      .compact
                      .select { |a| a != 'contains'}
                      .map { |a| a.delete(',') }
  else
    ingredients = m.split(' ').compact
    allergens = []
  end
  { ing: ingredients, all: allergens }
end

# Fill ingredients and allergens stat hashmaps
input.each do |i|
  i[:ing].each do |ing|
    ing_stat[ing] = { total: 0, all: {} } unless ing_stat.key? ing
    ing_stat[ing][:total] += 1
    i[:all].each do |all|
      ing_stat[ing][:all][all] = 0 unless ing_stat[ing][:all].key? all
      ing_stat[ing][:all][all] += 1
    end 
  end

  i[:all].each do |all|
    all_stat[all] = { total: 0, ing: {} } unless all_stat.key? all
    all_stat[all][:total] += 1
    i[:ing].each do |ing|
      all_stat[all][:ing][ing] = 0 unless all_stat[all][:ing].key? ing
      all_stat[all][:ing][ing] += 1
    end
  end
end

# Try to calculate which ingredient matches which allergen.
# The idea is that any allergen would match at least one ingredient in terms
# of total appearances number in the list.
allergens_map = {}
while allergens_map.keys.sort != all_stat.map { |a, _| a }.sort
  all_stat.each do |a, v|
    ing = v[:ing].keys.select { |k| !allergens_map.values.include?(k) && v[:ing][k] == v[:total] }
    allergens_map[a] = ing.first if ing.count == 1
  end
end

# Answer #1
puts ing_stat.keys
             .select { |k| !allergens_map.values.include?(k) }
             .map { |k| ing_stat[k][:total] }
             .sum

# Answer #2
puts allergens_map.map { |a, i| [a, i] }
                  .sort_by { |x| x[0] }
                  .map { |x| x[1] }
                  .join(',')
