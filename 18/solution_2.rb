OPS = {
  '+' => { priority: 1, left_associative: true, action: ->(x, y) { x + y } },
  '*' => { priority: 0, left_associative: true, action: ->(x, y) { x * y } },
  '-' => { priority: 1, left_associative: false, action: ->(x, y) { x - y } },
  '/' => { priority: 0, left_associative: false, action: ->(x, y) { x / y } }
}.freeze
LEFT_PARENTHESIS = '('.freeze
RIGHT_PARENTHESIS = ')'.freeze

def tokenize(expr)
  expr.gsub('+', ' + ')
      .gsub('*', ' * ')
      .gsub('-', ' - ')
      .gsub('/', ' / ')
      .gsub('(', ' ( ')
      .gsub(')', ' ) ')
      .split(' ')
      .compact
end

def priority(op)
  operator?(op) ? OPS[op][:priority] : 0
end

def operator?(token, ops = OPS.keys)
  ops.include? token
end

def left_parenthesis?(token)
  token == LEFT_PARENTHESIS
end

def right_parenthesis?(token)
  token == RIGHT_PARENTHESIS
end

def left_associative?(token)
  OPS[token][:left_associative]
end

def number?(token)
  true if Float(token)
rescue
  false
end

def shunting_yard(expr)
  op_stack = []
  output = []
  tokenize(expr).each do |token|
    # Debug output
    # puts "#{token} ; ops: #{op_stack.join(',')} ; output: #{output.join(',')}"
    if number?(token)
      output.push(token.to_f)
    else
      if operator?(token)
        while op_stack.count > 0 && (priority(op_stack.last) > priority(token) || (priority(op_stack.last) == priority(token) && left_associative?(token))) && !left_parenthesis?(op_stack.last)
          output.push(op_stack.pop)
        end
        op_stack.push(token)
      elsif left_parenthesis?(token)
        op_stack.push(token)
      elsif right_parenthesis?(token)
        while op_stack.count > 0 && !left_parenthesis?(op_stack.last)
          output.push(op_stack.pop)
        end
        op_stack.pop if left_parenthesis?(op_stack.last)
      else
        throw "Invalid symbol: #{token}"
      end
    end
  end
  output.push(op_stack.pop) while op_stack.count > 0
  output
end

def eval(expr)
  stack = []
  rpn = shunting_yard(expr)
  rpn.each do |o|
    # Debug output
    # puts "op: #{o}, stack: #{stack}"
    if operator?(o)
      op2 = stack.pop
      op1 = stack.pop
      e = OPS[o][:action].call(op1, op2)
      stack.push(e)
    else
      stack.push(o)
    end
  end
  stack.pop
end

expressions = File.read('input.txt').split("\n")

puts expressions.map { |e| eval(e) }.sum
