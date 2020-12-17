TOTAL_ROWS_COUNT = 128
TOTAL_COLS_COUNT = 8
ROW_SYMBOLS_COUNT = 7
SEAT_SYMBOLS_COUNT = 3

def binary_search(str, l_sym, r_sym, min, max)
  return str.first == r_sym ? max : min if str.count == 1
  if str.first == l_sym
    binary_search(str.drop(1), l_sym, r_sym, min, max - (max - min + 1) / 2)
  elsif str.first == r_sym
    binary_search(str.drop(1), l_sym, r_sym, min + (max - min + 1) / 2, max)
  else
    throw "Unknown symbol #{str.first}"
  end
end

def find_row(pass)
  binary_search(
    pass.chars.first(ROW_SYMBOLS_COUNT),
    'F', 'B',
    0, TOTAL_ROWS_COUNT - 1
  )
end

def find_col(pass)
  binary_search(
    pass.chars[ROW_SYMBOLS_COUNT..ROW_SYMBOLS_COUNT + SEAT_SYMBOLS_COUNT],
    'L', 'R',
    0, TOTAL_COLS_COUNT - 1
  )
end

def find_seat(pass)
  find_row(pass) * (TOTAL_COLS_COUNT) + find_col(pass)
end

boarding_passes = File.read('input.txt').split

boarding_passes.each do |pass|
  puts "#{pass} #{find_row(pass)} #{find_col(pass)} #{find_seat(pass)}"
end

puts boarding_passes.map { |pass| find_seat(pass) }.sort
