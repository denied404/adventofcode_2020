def integer?(str)
  str.scan(/\D/).empty?
end

def year?(str)
  integer?(str) && str.chars.count == 4
end

def valid_hgt?(str)
  return false unless str.length >= 4
  dim = str.chars.last(2).join
  val = str[0...-2]
  return false unless integer?(val)
  (dim == 'cm' && val.to_i >= 150 && val.to_i <= 193) ||
    (dim == 'in' && val.to_i >= 59 && val.to_i <= 76)
end

def valid_hcl?(str)
  str.match?(/^#[[:xdigit:]]{6}$/)
end

def valid_ecl?(str)
  valid_colors = %w(amb blu brn gry grn hzl oth).freeze
  valid_colors.include?(str)
end

def valid_pid?(str)
  str.scan(/\D/).empty? && str.length == 9
end

REQUIRED_FIELDS = {
  'byr' => ->(v) { year?(v) && v.to_i >= 1920 && v.to_i <= 2002 },
  'iyr' => ->(v) { year?(v) && v.to_i >= 2010 && v.to_i <= 2020 },
  'eyr' => ->(v) { year?(v) && v.to_i >= 2020 && v.to_i <= 2030 },
  'hgt' => ->(v) { valid_hgt?(v) },
  'hcl' => ->(v) { valid_hcl?(v) },
  'ecl' => ->(v) { valid_ecl?(v) },
  'pid' => ->(v) { valid_pid?(v) }
}.freeze

def required_fields?(passport)
  REQUIRED_FIELDS.keys - passport.map { |f| f.keys.first } == []
end

def valid?(passport)
  return false unless required_fields?(passport)
  passport.select { |f| REQUIRED_FIELDS.key?(f.keys.first) }
          .map do |f|
            REQUIRED_FIELDS[f.keys.first].call(f[f.keys.first])
          end
          .all?
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
