mem = Hash.new(0)

def apply_mask(str, mask)
  s = str.rjust(mask.length, '0')
  (0..mask.length - 1).to_a.map do |i|
    case mask[i]
    when '0'
      s[i]
    when '1'
      '1'
    else
      'X'
    end
  end.join
end

def generate_combinations(str)
  # The idea is to calculate total number of X's in masked address
  # and then just to generate binary representation of each (0..X - 1)
  # which will be the set of all possible combinations of zeros and ones
  # for given amount of X's
  x_pos = str.chars
             .each_with_index
             .map { |c, i| { pos: i, val: c } }
             .select { |x| x[:val] == 'X' }
             .map { |x| x[:pos] }
  (0..2**x_pos.count - 1).to_a.map do |c|
    bin = c.to_s(2).rjust(x_pos.length, '0').chars
    new_str = str.chars
    x_pos.each_with_index { |pos, i| new_str[pos] = bin[i] }
    new_str.join
  end
end

commands = []
File.read('input.txt').split(/\n/).map do |i|
  spl = i.split(' = ')
  if spl[0] == 'mask'
    commands.push(cmd: 'mask', val: spl[1])
  elsif spl[0][0..2] == 'mem'
    commands.push(cmd: 'mem',
                  val: spl[1].to_i,
                  addr: spl[0].scan(/\[(.*)\]/)[0][0].to_i.to_s(2))
  end
end

mask = ''
commands.each do |c|
  case c[:cmd]
  when 'mask'
    mask = c[:val]
  when 'mem'
    generate_combinations(apply_mask(c[:addr], mask)).each do |addr|
      mem[addr] = c[:val]
    end
  end
end

puts mem.values.sum
