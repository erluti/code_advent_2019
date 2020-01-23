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
    path = Pathfinder.new(self).path.count
  end
end

class KeytoDoorPathfinder
  def initialize(map,key,door)
    @map = map
    @keys_needed = []
    @path = path(key,door)
  end

  def keys_needed
    @keys_needed
  end

  def distance
    @path.count
  end

  private

  def path(start, stop)
    return @path if @path
    open_list = [{astar: 0, cost: 0, location: start, path: []}]
    closed_list = []

    while open_list.any?
      current = open_list.min { |node| node[:astar] }
      open_list.delete(current)

      closed_list << current

      if current[:location] == stop
        return @path = current[:path]
      end

      x, y = current[:location]
      children = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].select do |point|
        # false when it's a wall
        case value = @map.location(point)
        when '#'
          false
        when 'A'..'Z'
          # count the path, but track intervening doors
          @keys_needed << value.downcase
          true
        else
          true
        end
      end
      children.each do |child_location|
        node = {path: current[:path] + [current[:location]], location: child_location}
        next if closed_list.any?{|closed_node| closed_node[:location] == node[:location]}
        node[:cost] = 1 + current[:cost]
        node[:heuristic] = calculate_heuristic(child_location, stop)
        node[:astar] = node[:cost] + node[:heuristic]

        # if child is in the open_list's nodes positions and child cost is higher than the open_list node's cost skip it
        next if open_list.any? { |open_node| open_node[:location] == node[:location] && open_node[:astar] < node[:astar] }

        open_list << node
      end
    end
  end

  def calculate_heuristic(current_location, target)
    # try sum of (straight-line) distance to all keys
    x, y = current_location
    target_x, target_y = target
    Math.sqrt((x - target_x) ** 2 + (y - target_y) ** 2)
  end
end

class Pathfinder # use A* algorithm to find shortest path
  def initialize(map)
    @map = map
    @location = @map.start
    @keys_to_get = @map.keys
    @door_distances = {}
    @keys_to_get.each do |key|
      door = @map.find(key.upcase)
      next unless door
      @door_distances[key] = KeytoDoorPathfinder.new(@map, @map.find(key), door)
    end
  end

  def path
    give_up = Time.now + GIVE_UP_SECONDS
    # initial algorithm from https://medium.com/@nicholas.w.swift/easy-a-star-pathfinding-7e6689c7f7b2
    # Initialize both open and closed list
    open_list = NodeList.new
    open_list.add({astar: 0, cost: 0, location: @location, path: [], keys_collected: []})
    closed_list = NodeList.new

    # Loop until you find the end
    while open_list.any?
      raise "It's taking forever! (aka more than #{GIVE_UP_SECONDS} seconds)" if Time.now > give_up
      # let the currentNode equal the node with the least astar value
      current = open_list.next!

      keys_collected = current[:keys_collected].dup
      # collect key
      current_location = @map.location(current[:location])
      if @keys_to_get.include?(current_location) && !keys_collected.include?(current_location)
        keys_collected << current_location
      end

      # add the currentNode to the closed_list
      closed_list.add(current.dup)

      if (@keys_to_get - keys_collected).empty?
        # p current[:path]
        return current[:path]
      end

      # let the children of the currentNode equal the adjacent nodes
      x, y = current[:location]
      children = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].select do |point|
        # false when it's a wall
        case value = @map.location(point)
        when '#'
          false
        when 'A'..'Z'
          keys_collected.include?(value.downcase)
        else
          true
        end
      end

      missing_keys = @keys_to_get - keys_collected

      children.each do |child_location|
        node = {path: current[:path] + [current[:location]], location: child_location, keys_collected: keys_collected}
        next if closed_list.contains?(node)
        node[:cost] = 1 + current[:cost]
        node[:heuristic] = calculate_heuristic_add_door_distance(missing_keys, child_location)
        node[:astar] = node[:cost] + node[:heuristic]

        # if child is in the open_list's nodes positions and child cost is higher than the open_list node's cost skip it
        next if open_list.contains_better?(node)

        open_list.add(node)
      end
    end
  end

  # lower valued heuristics are choosen to traverse first
  # if it never overestimates the actual cost to get to the goal, it guarantees shortest path
  def calculate_heuristic(keys_to_get, current_location)
    # sum of (straight-line) distance to all keys
    x, y = current_location
    keys_to_get.sum do |key|
      next_x, next_y = @map.find(key)
      Math.sqrt((x - next_x) ** 2 + (y - next_y) ** 2)
    end
  end

  def calculate_heuristic_add_door_distance(keys_to_get, current_location)
    # try sum of distance to all keys plus distance of keys to their doors
    x, y = current_location
    keys_to_get.sum do |key|
      next_x, next_y = @map.find(key)
      Math.sqrt((x - next_x) ** 2 + (y - next_y) ** 2) + door_heuristic(key, keys_to_get)
    end
  end

  def door_heuristic(key, missing_keys)
    return 0 unless @map.find(key.upcase)
    # path distance for the desired door, plus key-door-distance for missing keys
    @door_distances[key].distance +
      (@door_distances[key].keys_needed & missing_keys).sum do |needed_key|
        @door_distances[needed_key].distance
      end
  end
end

class NodeList
  def initialize
    @list = Hash.new {|h,k| h[k] = []}
  end

  # removes a node with lowest astar and returns it
  def next!
    node = nil
    node_list = nil
    @list.each_value do |collection|
      next if collection.empty?
      lowest = collection.min { |node| node[:astar] }
      if node.nil? || lowest[:astar] < node[:astar]
        node = lowest
        node_list = collection
      end
    end
    node_list.delete(node) if node
    node
  end

  def add(new_node)
    @list[new_node[:keys_collected]] << new_node
  end

  def contains?(current)
    @list[current[:keys_collected]].any? {|node| node[:location] == current[:location]}
  end

  def contains_better?(current)
    # returns true if a similar node is listed with a lower astar
    @list[current[:keys_collected]].any? {|node| node[:location] == current[:location] && node[:cost] > current[:cost]}
  end

  def any?
    @list.values.any?(&:any?)
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