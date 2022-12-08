rows = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")

Tree = Struct.new(:x, :y, :height)

class TreesGrid

  def initialize(rows)
    @range = 1...(rows.first.size - 1)
    @nb_visible_by_design = (rows.first.size - 1) * 4
    parse_trees(rows)
  end

  def parse_trees(rows)
    @rows = rows.each_with_index.map do |row, y|
      row.split('').each_with_index.map do |val, x|
        Tree.new(x.to_i, y.to_i, val)
      end
    end
    @columns = @rows.transpose
  end

  def checkable_trees
    @_checkable_trees ||= @rows.slice(1...-1).map { |row| row.slice(1...-1) }.flatten
  end

  def left(tree)
    @rows[tree.y].filter { |t|  t.x < tree.x }
  end

  def right(tree)
    @rows[tree.y].filter { |t| t.x > tree.x }
  end

  def up(tree)
    @columns[tree.x].filter { |t| t.y < tree.y }
  end

  def down(tree)
    @columns[tree.x].filter { |t| t.y > tree.y }
  end

  def visible?(tree)
    %w[left right up down].any? { |dir| send(dir, tree).all? { |t| t.height < tree.height } }
  end

  def score(tree)
    %w[left right up down].reduce(1) do |res, dir|
      trees_in_line = send(dir, tree)
      trees_in_line.reverse! if %w[left up].include?(dir)
      index_first_higher = trees_in_line.find_index { |t| t.height >= tree.height }
      res * (index_first_higher.nil? ? trees_in_line.size : index_first_higher + 1)
    end
  end

  def count_visible_trees
    @nb_visible_by_design + checkable_trees.count { |tree| visible?(tree) }
  end

  def best_score_tree
    checkable_trees.map { |tree| score(tree) }.max
  end
end

trees = TreesGrid.new(rows)

# part 1
p trees.count_visible_trees # 1538

# part 2
p trees.best_score_tree