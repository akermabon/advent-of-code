rows = File.read(Dir.pwd + '/04/input.txt').split("\n")

pairs = rows.map do |row|
  row.split(',').map do |pair|
    from, to = pair.split('-').map(&:to_i)
    (from..to).to_a
  end
end

def overlapping_sections_size(pair)
  pair.reduce { |common, section| common & section }.size
end

def bad_assignment?(pair)
  smallest_size = pair.map(&:size).min
  overlapping_sections_size(pair) == smallest_size
end

def bad_assignments_count(pairs)
  pairs.count { |pair| bad_assignment?(pair) }
end

def overlapping_sections_count(pairs)
  pairs.count { |pair| overlapping_sections_size(pair) > 0 }
end

# part 1
p bad_assignments_count(pairs)

# part 2
p overlapping_sections_count(pairs)