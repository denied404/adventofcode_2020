mem = Hash.new(0)

def apply_mask(str, mask)
  s = str.rjust(mask.length, '0')
  masked = (0..mask.length - 1).to_a.map do |i|
    case mask[i]
    when '0'
      '0'
    when '1'
      '1'
    else
      s[i]
    end
  end.join
  masked.to_i(2)
end

commands = []
File.read('input.txt').split(/\n/).map do |i|
  spl = i.split(' = ')
  if spl[0] == 'mask'
    commands.push(cmd: 'mask', val: spl[1])
  elsif spl[0][0..2] == 'mem'
    commands.push(cmd: 'mem',
                  val: spl[1].to_i.to_s(2),
                  addr: spl[0].scan(/\[(.*)\]/)[0][0]).to_s.to_i
  end
end

mask = ''
commands.each do |c|
  case c[:cmd]
  when 'mask'
    mask = c[:val]
  when 'mem'
    mem[c[:addr]] = apply_mask(c[:val], mask)
  end
end

puts mem.values.sum
