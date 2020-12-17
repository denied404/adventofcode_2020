REQUIRED_FIELDS = %w(byr iyr eyr hgt hcl ecl pid).freeze

def valid?(passport)
  REQUIRED_FIELDS - passport.map { |f| f.keys.first } == []
end

# Input array preparation
passports = File.read('input.txt')
                .split(/\n{2,}/)
                .map do |p|
                  p.split(/[\n ]/).map do |e|
                    sp = e.split(':')
                    { sp[0] => sp[1] }
                  end
                end

puts passports.select { |p| valid?(p) }.count
