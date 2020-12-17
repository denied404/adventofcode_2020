raw_input = File.read('input.txt').split("\n\n")

rules = raw_input[0].split("\n").map do |r|
  name = r.split(':')[0]
  conditions = r.split(': ')[1].split(' or ').map do |c|
    boundary = c.split('-').map(&:to_i)
    { from: boundary[0], to: boundary[1] }
  end
  {
    condition: lambda do |x|
      conditions.map do |c|
        x >= c[:from] && x <= c[:to]
      end.any?
    end,
    name: name
  }
end

your_ticket = raw_input[1].split("\n")[1].split(',').map(&:to_i)
nearby_tickets = raw_input[2].split("\n")
                             .drop(1)
                             .map { |x| x.split(',').map(&:to_i) }

def invalid_values(ticket, rules)
  ticket.select { |t| !rules.map { |r| r[:condition].call(t) }.any? }
end

def valid?(ticket, rules)
  invalid_values(ticket, rules).empty?
end

valid_nearby_tickets = nearby_tickets.select { |t| valid?(t, rules) }

rules_mapping = {}

while rules_mapping.count < your_ticket.count do
  (0..your_ticket.count - 1).select { |i| !(rules_mapping.values.include? i) }.each do |idx|
    idx_values = valid_nearby_tickets.map { |t| t[idx] }.flatten
    rules_applied = rules.select { |r| !(rules_mapping.key? r[:name]) }
                          .map { |r| { name: r[:name], valid: valid?(idx_values, [r]) ? 1 : 0 } }
    if rules_applied.map { |r| r[:valid] }.reduce(:+) == 1
      name = rules_applied.select { |r| r[:valid] == 1 }.first[:name] 
      rules_mapping[name] = idx
      break
    end
  end
end

puts rules_mapping.keys.select { |k| k.start_with? "departure" }
                       .map { |r| your_ticket[rules_mapping[r]] }
                       .reduce(:*)
