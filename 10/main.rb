rows = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")

Cmd = Struct.new(:name, :value, :ticks)

class Clock
  def initialize(commands)
    @commands = commands
    @x_values = [1]
    run
  end

  def run
    @commands.each do |cmd|
      @x_values << @x_values.last
      @x_values << @x_values.last + cmd.value unless cmd.value.nil?
    end
  end

  def sum_strengths
    (20..220).step(40).to_a.map { |n| n * @x_values[n - 1] }.sum
  end

  def sprite(n)
    (@x_values[n] - 1..@x_values[n] + 1)
  end

  def display
    (0...240)
      .each_slice(40)
      .map { |row| row.map { |n| sprite(n).include?(n % 40) ? '#' : '.' }.join('') }
      .join("\n")
  end
end

commands = rows.map do |row|
  command, value = row.split(' ')
  Cmd.new(command, value&.to_i, 0)
end

clock = Clock.new(commands)

# part 1
p clock.sum_strengths

# part 2
puts clock.display
