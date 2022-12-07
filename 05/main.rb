rows = File.read(File.dirname(__FILE__) + '/input.txt')

crates_string, instructions_string = rows.split("\n\n")

def parse_crates(string)
  rows = string.split("\n")
  crates = 9.times.each_with_object([]) { |n, hash| hash[n] = [] }
  rows.each do |row|
    row.split('').each_slice(4).with_index { |group, col| crates[col].unshift(group[1]) if /[A-Z]/.match(group[1]) }
  end
  crates
end

def parse_instructions(string)
  string.split("\n").map do |row|
    nb_moves, from, to = /move (\d+) from (\d+) to (\d+)/.match(row).captures.map(&:to_i)
    { nb_moves: nb_moves, from: from - 1, to: to - 1 }
  end
end

def move(crates, nb_moves, from, to)
  crates_to_move = crates[from].pop(nb_moves)
  crates[to].push(*crates_to_move)
end

def move_with_3000(crates, todo)
  todo[:nb_moves].times { move(crates, 1, todo[:from], todo[:to])}
end

def move_with_3001(crates, todo)
  move(crates, todo[:nb_moves], todo[:from], todo[:to])
end

def top_with(crates, instructions, move_method)
  instructions.each { |todo| send(move_method, crates, todo) }
  crates.map { |stack| stack.last }.join
end

def copy(data)
  data.map(&:dup)
end

crates = parse_crates(crates_string)
instructions = parse_instructions(instructions_string)

# part 1
p top_with(copy(crates), instructions, :move_with_3000)

# part 2
p top_with(copy(crates), instructions, :move_with_3001)
