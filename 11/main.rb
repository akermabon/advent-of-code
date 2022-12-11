require 'byebug'
rows = File.read(File.dirname(__FILE__) + '/input.txt').split("\n\n")

ThrownItem = Struct.new(:worry, :monkey)

class Monkey

  attr_accessor :items, :divider, :nb_inspected, :relief

  def initialize(id, items, operation, divider, target_true, target_false)
    @id = id
    @items = items
    @operation = operation
    @divider = divider
    @target_true = target_true
    @target_false = target_false
    @nb_inspected = 0
  end

  def eval_op(old)
    eval(@operation)
  end

  def inspect_all
    thrown_items = []
    @items.size.times { thrown_items << inspect_item }
    thrown_items
  end

  def inspect_item
    item = @items.shift
    return if item.nil?

    @nb_inspected += 1
    worry = eval_op(item)
    worry = (worry / 3).floor if @relief
    ThrownItem.new(worry, worry % @divider == 0 ? @target_true : @target_false)
  end

  def to_s
    "Monkey #{@id} - items: #{@items.join(', ')} - nb_inspected: #{@nb_inspected}"
  end
end

class MonkeyBusiness
  def initialize(rows)
    @monkeys = parse_monkeys(rows)
  end

  def parse_monkeys(rows)
    rows.map.with_index do |monkey_rows, idx|
      items_row, op_row, test_row, if_true_row, if_false_row = monkey_rows.split("\n").slice(1..)
      items = /Starting items: (.*)/.match(items_row).captures.first.split(', ').map(&:to_i)
      operation = /Operation: new = (.*)/.match(op_row).captures.first
      divider = /Test: divisible by (\d+)/.match(test_row).captures.first.to_i
      target_true = /If true: throw to monkey (\d)/.match(if_true_row).captures.first.to_i
      target_false = /If false: throw to monkey (\d)/.match(if_false_row).captures.first.to_i
      Monkey.new(idx, items, operation, divider, target_true, target_false)
    end
  end

  def with_relief
    @monkeys.each { |monkey| monkey.relief = true }
    self
  end

  def with_max_divider
    @max_divider = @monkeys.map(&:divider).reduce(:*)
    self
  end

  def run(nb_rounds)
    nb_rounds.times { round }
    self
  end

  def round
    @monkeys.each do |monkey|
      monkey.inspect_all.each do |item|
        @monkeys[item.monkey].items << (@max_divider ? item.worry % @max_divider : item.worry)
      end
    end
  end

  def business_level
    @monkeys.map(&:nb_inspected).max(2).reduce(:*)
  end
end

# part 1
p MonkeyBusiness.new(rows).with_relief.run(20).business_level

# part 2
p MonkeyBusiness.new(rows).with_max_divider.run(10_000).business_level