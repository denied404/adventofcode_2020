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

ing_stat.each do |ing, val|
  puts "#{ing}: #{val[:all].keys.select { |a| val[:all][a] == val[:total] }.join(', ')}"
end

puts ing_stat
