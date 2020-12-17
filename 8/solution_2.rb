def evaluate(code, ctx)
  throw "Invalid cmd: #{code[:cmd]}" unless %w(acc nop jmp).include? code[:cmd]
  ctx[:passed_locs][ctx[:loc]] = true
  if code[:cmd] == 'acc'
    ctx[:acc] += code[:arg]
    ctx[:loc] += 1
  elsif code[:cmd] == 'jmp'
    ctx[:loc] += code[:arg]
  elsif code[:cmd] == 'nop'
    ctx[:loc] += 1
  end
  ctx[:op_count] += 1
end

def repetition?(ctx)
  ctx[:passed_locs].key? ctx[:loc]
end

def switch_cmd(code, line)
  if code[line][:cmd] == 'nop'
    code[line][:cmd] = 'jmp'
  elsif  code[line][:cmd] == 'jmp'
    code[line][:cmd] = 'nop'
  end
end

code = File.read('input.txt')
           .split(/\n/)
           .map { |c| { cmd: c.split(' ')[0], arg: c.split(' ')[1].to_i } }

(0..code.count - 1).each do |line|
  ctx = {
    acc: 0,
    loc: 0,
    op_count: 0,
    passed_locs: {}
  }

  switch_cmd(code, line)

  while ctx[:loc] < code.count && !repetition?(ctx)
    evaluate(code[ctx[:loc]], ctx)
  end

  unless repetition?(ctx)
    puts "Changed line #{line}, acc is #{ctx[:acc]}"
    break
  end

  switch_cmd(code, line)
end
