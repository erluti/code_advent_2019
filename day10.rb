require 'byebug'

class AsteroidMap
  def initialize(map_text)
    asteroids = []
    map_text.split("\n").each_with_index do |line, y|
      line.split('').each_with_index do |location, x|
        asteroids << [x, y] if location == "#"
      end
    end

    @all_asteroids = asteroids.dup

    @asteroids_in_line = Hash.new { |h,k| h[k] = [] }
    while base = asteroids.shift
      asteroids.each do |asteroid|
        m = slope(base, asteroid)
        b = base.last - (m * base.first) unless m == Float::INFINITY
        @asteroids_in_line[[m,b]] = @asteroids_in_line[[m,b]] | [base, asteroid]
      end
    end

    @memoized_asteroid_los_counts = Hash.new do |h,k|
      h[k] = @asteroids_in_line.count do |_, asteroids|
        asteroids.include?(k)
      end
    end
  end

  def max_visibility_count
    @memoized_asteroid_los_counts[maxsteroid]
  end

  def max_visibility_location
    maxsteroid
  end

private
  def slope(asteroid1, asteroid2)
    return Float::INFINITY if asteroid2.first - asteroid1.first == 0
    (asteroid2.last - asteroid1.last)/(asteroid2.first - asteroid1.first).to_f
  end

  def maxsteroid
    @maxsteroid ||= @all_asteroids.max do |asteroid1, asteroid2|
      @memoized_asteroid_los_counts[asteroid1] <=> @memoized_asteroid_los_counts[asteroid2]
    end
  end
end

# class Asteroid
#   attr_reader :x, :y
#   def initialize(x,y)
#     @x, @y = x, y
#   end

#   def point
#     [@x, @y]
#   end

#   def slope(other)
#     (other.y - @y)/(other.x - @x)
#   end
# end

if __FILE__ == $0
  map = AsteroidMap.new(DATA.read)
  print "\nNumber of asteroids detected from best location: #{map.max_visibility_count}\n\n"
end

__END__
.#.####..#.#...#...##..#.#.##.
..#####.##..#..##....#..#...#.
......#.......##.##.#....##..#
..#..##..#.###.....#.#..###.#.
..#..#..##..#.#.##..###.......
...##....#.##.#.#..##.##.#...#
.##...#.#.##..#.#........#.#..
.##...##.##..#.#.##.#.#.#.##.#
#..##....#...###.#..##.#...##.
.###.###..##......#..#...###.#
.#..#.####.#..#....#.##..#.#.#
..#...#..#.#######....###.....
####..#.#.#...##...##....#..##
##..#.##.#.#..##.###.#.##.##..
..#.........#.#.#.#.......#..#
...##.#.....#.#.##........#..#
##..###.....#.............#.##
.#...#....#..####.#.#......##.
..#..##..###...#.....#...##..#
...####..#.#.##..#....#.#.....
####.#####.#.#....#.#....##.#.
#.#..#......#.........##..#.#.
#....##.....#........#..##.##.
.###.##...##..#.##.#.#...#.#.#
##.###....##....#.#.....#.###.
..#...#......#........####..#.
#....#.###.##.#...#.#.#.#.....
.........##....#...#.....#..##
###....#.........#..#..#.#.#..
##...#...###.#..#.###....#.##.