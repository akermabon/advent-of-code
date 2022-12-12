require 'set'
rows = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")

def ord(val)
  return 'a'.ord if val == 'S'
  return 'z'.ord if val == 'E'
  val.ord
end

Node = Struct.new(:x, :y, :alt, :char)

class Climb
  def initialize(rows)
    @grid = parse_grid(rows)
  end

  def parse_grid(rows)
    rows.each_with_index.reduce([]) do |grid, (row, y)|
      row.split('').each_with_index do |val, x|
        grid << Node.new(x.to_i, y.to_i, ord(val), val)
      end
      grid
    end
  end

  def candidates(from)
    @grid.filter do |node|
      next if node == from
      next if (node.x - from.x).abs > 1
      next if (node.y - from.y).abs > 1
      next if (node.x - from.x).abs == 1 && (node.y - from.y).abs == 1
      next if from.alt - node.alt > 1
      true
    end
  end

  def shortest_path(to)
    from = @grid.find { |node| node.char == 'E' }
    queue = [[from, 0]]
    visited = Set.new
    visited << from

    while queue.any?
      current_node, path_size = queue.shift
      return path_size if current_node.char == to

      candidates(current_node).reject { |node| visited.include?(node) }.each do |node|
        visited << node
        queue << [node, path_size + 1]
      end
    end
  end
end

climb = Climb.new(rows)

# part 1
p climb.shortest_path('S')

# part 2
p climb.shortest_path('a')