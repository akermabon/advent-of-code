rows = File.read(File.dirname(__FILE__) + '/input.txt').split("\n\n")

def all_sorted_calories(rows)
  rows
    .map { |one_elf| one_elf.split("\n").map(&:to_i).sum }
    .sort
    .reverse
end

def max_calories(rows)
  all_sorted_calories(rows).first
end

def top3_sum_calories(rows)
  all_sorted_calories(rows).take(3).sum
end

# part 1
p max_calories(rows)

# part 2
p top3_sum_calories(rows)