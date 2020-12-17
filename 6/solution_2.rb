input_answers = File.read('input.txt')
                    .split(/\n{2,}/)
                    .map { |g| g.split(/\n/) }

unique_yeses = []

input_answers.each do |group_answers|
  unique_answers = Hash.new(0)
  group_answers.each do |answers|
    answers.chars.each do |answer|
      unique_answers[answer] += 1
    end
  end
  unique_yeses.push(
    unique_answers.select { |_, v| v == group_answers.count }
                  .keys
                  .count
  )
end

puts unique_yeses.reduce(&:+)
