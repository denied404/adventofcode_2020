raw_input = File.read('input.txt').split("\n\n")

rules = raw_input[0].split("\n").map do |r|
  # name = r.split(':')[0]
  conditions = r.split(': ')[1].split(' or ').map do |c|
    boundary = c.split('-').map(&:to_i)
    { from: boundary[0], to: boundary[1] }
  end
  ->(x) { conditions.map { |c| x >= c[:from] && x <= c[:to] }.any? }
end

# your_ticket = raw_input[1].split("\n")[1].split(',').map(&:to_i)
nearby_tickets = raw_input[2].split("\n")
                             .drop(1)
                             .map { |x| x.split(',').map(&:to_i) }

def invalid_values(ticket, rules)
  ticket.select { |t| !rules.map { |r| r.call(t) }.any? }
end

puts nearby_tickets.map { |t| invalid_values(t, rules).reduce(:+).to_i }
  .reduce(:+)
