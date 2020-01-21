require 'byebug'

GIVE_UP_SECONDS = 15

class VaultMap
  attr_reader :keys, :start
  def initialize(text)
    @map = Hash.new { |h,k| h[k] = [] }
    @keys = []
    text.split("\n").each_with_index do |row, i|
      @map[i] = row.split('')
      @keys += row.scan(/[a-z]/)
      if position = @map[i].index('@')
        @start = [position,i]
      end
    end
    @keys.sort!
  end

  def location(x,y=nil)
    if x.is_a? Array
      x,y = x
    end
    @map[y][x]
  end

  def find(value)
    @map.each_with_index do |row, y|
      x = row.last.index(value)
      return [x, y] if x
    end
    nil
  end

  def steps
    Pathfinder.new(self).path.count
  end
end

class Pathfinder # use A* algorithm to find shortest path
  def initialize(map)
    @map = map
    @location = @map.start
    @keys_to_get = @map.keys
    # @keys_collected = []
  end

  def path
    give_up = Time.now + GIVE_UP_SECONDS
    # initial algorithm from https://medium.com/@nicholas.w.swift/easy-a-star-pathfinding-7e6689c7f7b2
    # Initialize both open and closed list
    open_list = NodeList.new
    open_list.add({astar: 0, cost: 0, location: @location, previous: nil, keys_collected: []})
    closed_list = NodeList.new

    # Loop until you find the end
    while open_list.any?
      raise "It's taking forever! (aka more than #{GIVE_UP_SECONDS} seconds)" if Time.now > give_up
      # let the currentNode equal the node with the least astar value
      current = open_list.next!

      # collect key
      current_location = @map.location(current[:location])
      if @keys_to_get.include?(current_location) && !current[:keys_collected].include?(current_location)
        current[:keys_collected] << current_location
      end

      # add the currentNode to the closed_list
      closed_list.add(current.dup)

      if (@keys_to_get - current[:keys_collected]).empty?
        path = []
        while current[:previous]
          path << current[:location]
          current = current[:previous]
        end
        # the nil previous is the starting position, so it's not part of the path
        return path
      end


      # let the children of the currentNode equal the adjacent nodes
      x, y = current[:location]
      children = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].select do |point|
        # false when it's a wall
        case value = @map.location(point)
        when '#'
          false
        when 'A'..'Z'
          current[:keys_collected].include?(value.downcase)
        else
          true
        end
      end

      children.each do |child_location|
        node = {previous: current, location: child_location, keys_collected: current[:keys_collected].dup}
        next if closed_list.contains?(node)
        node[:cost] = 1 + current[:cost]
        node[:heuristic] = calculate_heuristic(@keys_to_get - current[:keys_collected], child_location) / 1000
        # node[:heuristic] = (calculate_heuristic_avoid_doors(@keys_to_get - current[:keys_collected], child_location) + calculate_heuristic_by_keys_away_from_doors(@keys_to_get - current[:keys_collected], child_location)) / 2000
        node[:astar] = node[:cost] + node[:heuristic]

        # if child is in the open_list's nodes positions and child cost is higher than the open_list node's cost skip it
        next if open_list.contains_better?(node)

        open_list.add(node)
      end
    end
  end

  def calculate_heuristic(keys_to_get, current_location)
    heuristic = 0
    x, y = current_location
    keys_to_get.each_with_index do |key, i|
      next_x, next_y = @map.find(key)
      heuristic += ((x - next_x) ** 2 + (y - next_y) ** 2) / (i + 1)
    end
    heuristic
  end

  def calculate_heuristic_avoid_doors(keys_to_get, current_location)
    heuristic = 0
    x, y = current_location
    keys_to_get.each_with_index do |key, i|
      one_dex = i + 1
      next_x, next_y = @map.find(key)
      heuristic += ((x - next_x) ** 2 + (y - next_y) ** 2) / one_dex
      # avoid locked doors
      bad_x, bad_y = @map.find(key.upcase)
      next if bad_x == nil # no door for some keys
      heuristic -= (((x - bad_x) ** 2 + (y - bad_y) ** 2) / one_dex) * 2 # better to avoid doors
    end
    heuristic
  end

  def calculate_heuristic_by_keys_away_from_doors(keys_to_get, current_location)
    # pursue keys that are farther from their doors first
    heuristic = 0
    x, y = current_location
    keys_to_get.sort! do |key1, key2|
      door1 = @map.find(key1.upcase)
      door2 = @map.find(key2.upcase)
      if door1.nil?
        if door2.nil?
          # no doors, favor closer one
          key1_loc = @map.find(key1)
          key2_loc = @map.find(key2)
          ((x - key1_loc.first) ** 2 + (y - key1_loc.last) ** 2) <=> ((x - key2_loc.first) ** 2 + (y - key2_loc.last) ** 2)
        else
          # key1 has no door, favor key2
          1
        end
      else
        if door2.nil?
          # key2 has no door, favor key1
          -1
        else
          # both have doors, favor key farthest from it's door
          key1_loc = @map.find(key1)
          key2_loc = @map.find(key2)
          ((door1.first - key1_loc.first) ** 2 + (door1.last - key1_loc.last) ** 2) <=> ((door2.first - key2_loc.first) ** 2 + (door2.last - key2_loc.last) ** 2)
        end
      end
    end.each_with_index do |key, i|
      next_x, next_y = @map.find(key)
      heuristic += ((x - next_x) ** 2 + (y - next_y) ** 2) / (i + 1)
    end
    heuristic
  end
end

class NodeList
  def initialize
    # REVIEW - could be hashes indexed by keys collected to handle the "relevant_list" bit below
    @list = []
  end

  # removes a node with lowest astar and returns it
  def next!
    node = @list.min { |node| node[:astar] }
    @list.delete(node)
  end

  def add(new_node)
    @list << new_node
  end

  def contains?(current)
    @list.select {|node| node[:keys_collected] == current[:keys_collected]}.any? {|node| node[:location] == current[:location]}
  end

  def contains_better?(current)
    # returns true if a similar node is listed with a lower astar
    @list.select {|node| node[:keys_collected] == current[:keys_collected]}.any? {|node| node[:location] == current[:location] && node[:cost] > current[:cost]}
  end

  def any?
    @list.any?
  end
end

if __FILE__ == $0
  vault = VaultMap.new(DATA.read)

  print "Steps to collect all keys: #{vault.steps}\n\n"
end

__END__
#################################################################################
#...#.............#...#.W...............#.#...#.....#.........#.#.......#.......#
#.#.#.#.#########.#.#.#.###############.#.#.#.#.#.#.#.#.#####.#.#.#####.#.###.#.#
#.#...#.#.......#.#.#.#.#.......#.......#...#.#.#.#.#.#g#...#.#.....#.#..d..#.#.#
#.#####.#.#####.#.#D#.#.#.###.###.#######.###.#.#.#.#.#.#.#.#.#####.#.#######.#.#
#v..#.#.#.#.#...#.#.#...#.#...#...#.....#...#...#.#.#.#.#.#.#.....#...#...#...#.#
###.#.#.#.#.#.#####.#####.###.#.###.###.###.#####.#.#.#.#.#U#####.#####.#.#.###.#
#...#...#.#.#.#...#...#.....#.#.#.....#.#...#...#.#.#.#.#.#...#...#.....#...#.#.#
#.#######.#.#.#.#.###.#.###.#C#.#######.#.###.#.#.#.#.###.###.#.###.#########.#.#
#...#...#.#.#...#...#.#.#...#.#..t......#.#.#.#...#.#...#.#x..#.#...#.........#.#
#.#.#.#.#.#.#######.#.#.#.###.#########.#.#.#.#########.#.#.###.#.###.#######.#.#
#.#.#.#...#.......#.#.#.#...#.#.....#...#...#.........#...#.#..a..#...#..w....#.#
###.#.#####.###.###.#.#.###.###.###.#.#####.#########.#####.#.#########.###.###.#
#...#...#...#...#...#.#.#...#...#...#...#e#.....#...#...#...#.#..o#.....#.#.#...#
#.#.###.#.###.###.###.#.#.###.###.#####.#.#####.#.#.###.#.#####.#.#.#####.#.#.###
#.#.#.#...#...#.F.#...#.#.....#.#.......#.#.....#.#.#...#.....X.#.#...#.....#.#.#
#.#.#.#####.###.###.#######.###.#########.#.#####.###.###########.###.###.###.#.#
#.#.....#.....#.#...#.G...#...#...#.....#.#.......#...#.........#...#...#...#...#
#.#.#####.#####.#.###.###.###.#.#.#.###.#.#######.#.###.#####.#####.#.#.#######T#
#.#.#.....#.....#.#..u#...#.#.#.#.#.#.#.#.#.L.....#.....#.#...#.....#.#...#.....#
#.#.#.#####.###.#.#.###.###.#.#.###.#.#.#.#.#############.#.###.#########.#.#####
#.#.#.....#.#...#.#...#.#.#...#.#.....#.#...#.............#.#.#.....#j..#.......#
#.#######.#.#.###A#####.#.#.###.#.#####.#.###.###########.#.#Q#.###.#.#.#######.#
#.......#.#.#...#.......#.#.#.......#...#...#.....#.......#.#.#.O.#...#.....#...#
#.#.#.###.#.#############.#.#########.#.###.#.###.#########.#.#############J#.###
#.#.#z#...#...............#.#...#...#.#.#.#.#.#...#...#.....#.....#k..N...#.#...#
#.#.###.###############.###.#.#.#.#.#.#.#.#.###.###.#.#.#.#######.#.#####.#.###.#
#.#...#...#.....#.......#...#.#...#...#.#.#.#...#...#...#.#....q..#...#.#.#.#...#
#####.###.#.###.#.#######.###.###########.#.#.###.###.#####.#######.#.#.#.#.#.###
#.......#.#.#.#.#.........#.............#.#.#...#.#...#...#.#.......#.#n..#.#.#c#
#.#.#####.#.#.#.###############.#######.#.#.#.#.#.#.###.#.#.#########.#.###.#.#.#
#.#.#...#...#.#.....#.........#.#...#...#.#.#.#.#.#...#.#.#.......K...#.....#...#
#.###.#.#####.#####.#####.###.#.#.#.#.#.#.#.###.#.#.###.#.#####################.#
#.#...#...#.......#.......#...#...#.#.#.#.#.#...#.#.#...#.................#.....#
#.#.###.###Y#.#############.#######.#.#.#.#.#.###.###.#######.#########.###.#####
#.#.#.#.....#.#...........#.#.....#.#.#.#.#.#.#...#...#.....#.#...#...#.#...#...#
#.#.#.#######.#.###.#####.#.#.#.#.###.#.#.#.#.#.#.#.###.###.#.#.#.#.#.###.###.#.#
#...#.......#...#.#...#...#.#.#.#...#.#.#...#.#.#.#.#.....#.#.#.#...#...#.....#i#
#M###.#####.#####.###.#####.###.###.#.#.#.###.#.###.#######.#.#.#######.#######.#
#....b#.............#...........#.....#.......#.............#.........#.........#
#######################################.@.#######################################
#.#.......#...#.......#.......#.....#.....#...#...............#.....B.....#.....#
#.#.#.###.#.###.#.###.#.#####.#.###.#.#.#.#.#.#.#####.#####.###.#.#########.###.#
#...#.#.....#...#.#.#.#.#...#.#.#...#.#.#...#.#.#.#...#.....#...#.#.....#...#.#.#
#H###.#.#####.###.#.#.#.###.#.#.#.###.#.#.###.#.#.#.#.#######.###.#.###.#.###.#.#
#.#...#...#...#.#.#.#.#.#...#...#.....#.#...#...#.#.#.#...#...#...#.#.#.#.#...#.#
#.#.#####.#.###.#.#.#.#.#.#############.###.#####.#.#.#.#.#.###.###.#.#.#.#.#.#.#
#.#.....#.#...#.#.#...#.#.....#.....#...#...#.....#.#.#.#.#.#.#...#...#...#.#.#.#
#.#####.#.###.#.#.###.#.#.#.###.###.#.#.#.#######.#.###.#.#.#.###.###.#####.#.#.#
#.....#.#.#.#.#.#...#.#.#.#...#...#.#.#.#.........#.....#.#.....#.#...#.....#.#f#
#######.#.#.#.#.###.###.#####.#.###.#.###########.#######.#.#####.#.#####.#.#.#.#
#.......#...#.....#.....#...#...#...#..l#.......#.#.......#.#.....#.#...#.#.#.#.#
#.#######.###.#####.#####.#.#####.#.###.#.#.#####.#.#####.#.#.#####.#.#.###.###.#
#...#.I.#.#...#...#.......#.......#.#...#.#.......#...#..y#.#...Z.#.#.#...#.#...#
###.#.###.#.###.#.#############.#####.#.#.###########.#####.#####.#.#V###.#.#.#.#
#...#.....#.#...#...#...........#.....#.#...E.......#.....#...#.#...#.#.....#.#.#
#.#######.#.#.#####.#####.#######.#################.#####.###.#.#####.#.#####.###
#...P...#.#.#.#...#.....#.#.....#...#...#.........#...#.#.....#..m..#.#.#...#...#
#.#####.###.#.#.#.#####.###.###.#.#.#.#.#.#.#########.#.#######.###.#.#R#.#.###.#
#.#.....#...#...#.#.......#.#.#.#.#...#.#.#...#.....#.....#.....#...#.#.#.#...#.#
#.#.#####.#######.#######.#.#.#.#######.#.###.#.###.#####.#.#####.###.#.#.###.#.#
#.#.....#.....#.#...#.#.....#...#.......#...#.#.#.#.....#.#.#.#...#...#.#.#.#...#
#######.#####.#.###.#.#######.###.#########.#.#.#.#####.#.#.#.#.###.###.#.#.###.#
#.........#.#...#...#.....#.#...#.......#...#.#...#.....#...#.#.#...#...#.#.....#
#.#######.#.###.#.#.#####.#.###.#.#####.#.###.###.#.#####.###.#.###.#.###.###.###
#...#.........#.#.#...#...#.#...#...#.#.#.#.#...#.#.#.....#...#.#...#...#...#..p#
###.#.#########.#.#####.###.#.#####.#.#.#.#.###.#.#.#.#####.###.#.#####.###.###.#
#...#.#.........#.......#.#...#.......#.#.#...#.#.#.#.#.#...#.#.#.#...#.#.#...#.#
#.###.#.#################.#.#########.#.#.###.#.#.#.#.#.#.###.#.#.###.#.#.###.#.#
#...#.#.#.......#...#.....#.#.......#.#.#.#...#...#.#.#.#...#...#...#.....#.#.#.#
#.#.###.#.###.#.#.#.#####.#.###.###.#.#.#.#.#######.#.#.###.#.###.#.#####.#.#.###
#.#...#.#.#...#.#.#...#...#...#...#.#.#.#...#.....#.#...#...#.#...#...#.....#...#
#####.#.###.###.#.###.#.#.###.###.#.###.#.###.###.#.###.#.###.#######.#.#######.#
#..r#.#...#.#.....#...#s#...#.....#...#.#.#...#.#.#.#...#.#...#.......#.#...S...#
#.#.#.###.#.#######.###.#############.#.###.###.#.#.#.###.#.###.#######.#.#####.#
#.#.....#.#.#...#.#...#.........#...#.#.#...#.......#...#.#.....#.#.....#.#.#...#
#.#######.#.#.#.#.###.#.###.###.#.#.#.#.#.#############.#.#######.#.#####.#.#.###
#.#.....#.#...#.#.....#...#.#...#.#.#...#.....#...#...#.#.....#.....#..h..#.#.#.#
#.#.###.#.#####.#.#########.#.###.#.#####.###.#.#.#.#.#.#####.#######.#####.#.#.#
#.....#.........#...........#.....#.....#...#...#...#.......#.........#.........#
#################################################################################