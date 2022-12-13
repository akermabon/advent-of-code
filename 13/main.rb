require 'byebug'
rows = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")

class Distress
  def initialize(rows)
    @signals = parse_signals(rows)
    @dividers = [[[2]], [[6]]]
  end

  def parse_signals(rows)
    rows.filter_map do |row|
      next false if row == ''
      eval(row)
    end
  end

  def compare(left_array, right_array)
    return 0 if left_array == right_array

    left_array.each_with_index do |left, idx|
      right = right_array[idx]
      return 1 if right.nil?

      next if left == right
      return left <=> right if left.is_a?(Integer) && right.is_a?(Integer)

      left = [left] if left.is_a?(Integer)
      right = [right] if right.is_a?(Integer)

      return compare(left, right) if left != right
    end
    -1 # right size > left size
  end

  def sum_ordered_pairs_indexes
    @signals.each_slice(2).filter_map.with_index { |pair, idx| compare(pair[0], pair[1]) == -1 ? idx + 1 : false}.sum
  end

  def decoder_key
    sorted_signals = (@signals + @dividers).sort(&method(:compare))
    @dividers.map { |divider| sorted_signals.find_index(divider) + 1 }.reduce(&:*)
  end
end

distress = Distress.new(rows)

# part 1
p distress.sum_ordered_pairs_indexes

# part 2
p distress.decoder_key

