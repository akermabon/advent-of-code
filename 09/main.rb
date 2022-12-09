require 'byebug'
require 'set'
rows = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")

Pos = Struct.new(:x, :y)

class Knot

  attr_accessor :x, :y

  def initialize
    @x = 0
    @y = 0
  end

  def to_s
    "(#{@x}, #{@y})"
  end

  def move(dir)
    case dir
    when 'L'
      @x -= 1
    when 'R'
      @x += 1
    when 'U'
      @y += 1
    when 'D'
      @y -= 1
    end
  end

  def diff(from)
    Pos.new(@x - from.x, @y - from.y)
  end
end

class Rope
  def initialize(moves, nb_knots)
    @moves = moves
    @nb_knots = nb_knots
    @tail_used_cells = Set.new
    init_knots
    simulate
  end

  def init_knots
    @knots = []
    @nb_knots.times { @knots << Knot.new }
    @head = @knots.first
    @tail = @knots.last
    @tail_used_cells << @tail
  end

  def close_enough?(diff)
    diff.x.abs < 2 && diff.y.abs < 2
  end

  def calc_coord_from_diff(knot, diff)
    diff > 0 ? knot + 1 : knot - 1
  end

  def move_knot(knot, next_knot)
    diff = next_knot.diff(knot)
    return if close_enough?(diff)

    @tail_used_cells << knot.to_s if @tail == knot
    knot.x = calc_coord_from_diff(knot.x, diff.x) unless diff.x == 0
    knot.y = calc_coord_from_diff(knot.y, diff.y) unless diff.y == 0
  end

  def simulate
    @moves.each do |move|
      move[:nb_steps].times do
        @head.move(move[:dir])
        (1...@nb_knots).each do |idx|
          move_knot(@knots[idx], @knots[idx-1])
        end
      end
    end
  end

  def count_tail_used_cells
    @tail_used_cells.count
  end
end

moves = rows.map do |row|
  dir, nb_steps = row.split(' ')
  %i[dir nb_steps].zip([dir, nb_steps.to_i]).to_h
end

# part 1
p Rope.new(moves, 2).count_tail_used_cells

# part 2
p Rope.new(moves, 10).count_tail_used_cells