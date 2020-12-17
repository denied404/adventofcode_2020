ctx = {
  acc: 0,
  loc: 0,
  op_count: 0,
  passed_locs: {}
}

def evaluate(cmd, arg, ctx)
  throw "Invalid syntax #{cmd}" unless %w(acc nop jmp).include? cmd
  ctx[:passed_locs][ctx[:loc]] = true
  if cmd == 'acc'
    ctx[:acc] += arg
    ctx[:loc] += 1
  elsif cmd == 'jmp'
    ctx[:loc] += arg
  elsif cmd == 'nop'
    ctx[:loc] += 1
  end
  ctx[:op_count] += 1
end

code = File.read('input.txt')
           .split(/\n/)
           .map { |c| { cmd: c.split(' ')[0], arg: c.split(' ')[1].to_i } }

while ctx[:loc] <= code.count && ctx[:op_count] < 2000
  puts "#{code[ctx[:loc]][:cmd]} #{code[ctx[:loc]][:arg]}, next loc: #{ctx[:loc]}, acc: #{ctx[:acc]}, repetitions: #{ctx[:passed_locs].key? ctx[:loc]}"
  evaluate(code[ctx[:loc]][:cmd], code[ctx[:loc]][:arg], ctx)
end
