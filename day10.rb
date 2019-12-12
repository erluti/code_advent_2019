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
        if m == Float::INFINITY
          b = asteroid.first # set b to the x value because this line is vertical (this is admitedly hackish, but I blame infinity)
        else
          b = base.last - (m * base.first) # b is the y-intercept of a line
        end
        @asteroids_in_line[[m,b]] = @asteroids_in_line[[m,b]] | [base, asteroid]
      end
    end

    @asteroids_in_line.each do |line_params, asteroids|
      if line_params.first == 0 #horizontal line
        asteroids.sort! { |a,b| a.first <=> b.first } #sort by x coordinate
      else
        asteroids.sort! { |a,b| a.last <=> b.last } #sort by y coordinates
      end
    end

    # byebug
    # lines = @asteroids_in_line.select {|line, points| points.include?([11,13])}
    # lines.select {|line, points| points.first != [11,13] && points.last != [11,13]}.values.map(&:count)

    @memoized_asteroid_los_counts = Hash.new do |h,k|
      h[k] = @asteroids_in_line.collect do |_, asteroids|
        if asteroids.include?(k)
          if asteroids.first == k || asteroids.last == k
            1 # if it's first or last in the list of asteroids, count once
          else
            2 # if it's in the middle it can see an asteroid on either side
          end
        else
          0
        end
      end.sum
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

    # as Rational numbers instead of rounded floats, but doesn't change result of specs
    # y_diff = asteroid2.last - asteroid1.last
    # x_diff = asteroid2.first - asteroid1.first
    # sign = (y_diff <=> 0) * (x_diff <=> 0)
    # Rational("#{sign * y_diff.abs}/#{x_diff.abs}")

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