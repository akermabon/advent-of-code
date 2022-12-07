rows = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")

class FileSystem
  def initialize
    @dir_paths = []
    @total_space = 70_000_000
    @used_space = 0
    @data = { '/': {} }
    @cwd = '/'
  end

  def content(path = @cwd)
    @data.dig(*path.split('.').map(&:to_sym))
  end

  def mkdir(name)
    content[name.to_sym] = {}
    @dir_paths << [@cwd, name].join('.')
  end

  def touch(size, name)
    content[name.to_sym] = size.to_i
    @used_space = @used_space + size.to_i
  end

  def cd(target)
    @cwd = @cwd.split('.').slice(0...-1).join('.') and return if target == '..'
    @cwd = [@cwd, target].join('.') if target != '/'
  end

  def print(data = @data, level = 0)
    data.each do |key, value|
      padding = ' ' * 2 * level
      next puts "#{padding}- #{key} (file, size=#{value})" if value.is_a?(Integer)
      puts "#{padding}- #{key} (dir)"
      print(value, level + 1)
    end
  end

  def dir_size(path)
    content(path).reduce(0) do |sum, (key, value)|
      next sum + dir_size([path, key].join('.')) if value.is_a?(Hash)
      sum + value
    end
  end

  def dir_sub_100k_size
    @dir_paths.map { |path| dir_size(path) }.filter { |size| size <= 100_000 }.sum
  end

  def delete_for_space(needed_space)
    @dir_paths.map { |path| dir_size(path) }.filter { |size| size >= needed_space}.min
  end

  def smallest_dir_to_free_space(target_space)
    free_space = @total_space - @used_space
    needed_space = target_space - free_space
    delete_for_space(needed_space)
  end
end

def build_fs(rows)
  fs = FileSystem.new
  rows.each do |row|
    fs.cd(row.split(' ').last) and next if row.start_with?('$ cd')
    fs.touch(*row.split(' ')) and next if row.start_with?(/\d+/)
    fs.mkdir(row.split(' ')[1]) if row.start_with?('dir')
  end
  fs
end

fs = build_fs(rows)

# part 1
p fs.dir_sub_100k_size

# part 2
p fs.smallest_dir_to_free_space(30_000_000)
