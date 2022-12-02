rows_by_elf = File.read(Dir.pwd + '/01/input.txt').split("\n\n")

all_calories = rows_by_elf
  .map { |one_elf| one_elf.split("\n").map(&:to_i).sum }
  .sort
  .reverse

# part 1
max_calories = all_calories.first
puts "max calories: #{max_calories}"

# part 2
top3_sum = all_calories.take(3).sum
puts "sum of the top 3: #{top3_sum}"