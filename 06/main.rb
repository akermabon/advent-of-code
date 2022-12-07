packet = File.read(File.dirname(__FILE__) + '/input.txt')

def is_marker?(string)
  splitted = string.split('')
  splitted.size == splitted.uniq.size
end

def find_first_marker(packet, marker_size)
  packet.split('').each_with_index.find_index do |_, index|
    next false if index < (marker_size - 1)
    substring = packet.slice(index - (marker_size - 1)..index)
    is_marker?(substring)
  end + 1
end

# part 1
p find_first_marker(packet, 4)

# part 2
p find_first_marker(packet, 14)