items = File.read(Dir.pwd + '/03/input.txt').split("\n")

SCORES = ('a'..'z').each_with_index.each_with_object({}) { |(letter, index), hash| hash[letter] = index + 1 }
('A'..'Z').each_with_index { |letter, index| SCORES[letter] = index + 27 }

def common_item(compartments)
  (compartments[0] & compartments[1]).first
end

def stacks(items)
  items.map { |row| row.split('') }
end

def compartments(stack)
  compartment_size = stack.size / 2
  [stack.take(compartment_size), stack.last(compartment_size)]
end

def badge(stacks)
  (stacks[0] & stacks[1] & stacks[2]).first
end

def sum_priorities_common_item(items)
  stacks(items).map { |stack| SCORES[common_item(compartments(stack))] }.sum
end

def sum_badge_priorities(items)
  stacks(items).each_slice(3).map { |group_stacks| SCORES[badge(group_stacks)] }.sum
end

# part 1
p sum_priorities_common_item(items)

# part 2
p sum_badge_priorities(items)