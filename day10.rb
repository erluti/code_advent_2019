require 'byebug'

# TODO the next step in debugging would be to display the map show the maxsteroid and marking each other asteroid as visible or blocked (use a letter, caps for vizible, lower for blocked like example)

class AsteroidMap
  def initialize(map_text)
    map_lines = map_text.split("\n")
    @width = map_lines.first.length
    @height = map_lines.count

    asteroids = []
    map_lines.each_with_index do |line, y|
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
      lines = @asteroids_in_line.select {|line, points| points.include?(k)}
      h[k] = lines.collect do |_, asteroids|
        if asteroids.first == k || asteroids.last == k
          1 # if it's first or last in the list of asteroids, count once
        else
          2 # if it's in the middle it can see an asteroid on either side
        end
      end.sum
    end

    def display(asteroid_base)
      letters = ('AA'..'ZZ').to_a
      display_values = {}
      lines_of_sight = @asteroids_in_line.select { |line, points| points.include?(asteroid_base) }
      lines_of_sight.keys.each do |line_params|
        display_values[line_params] = letters.shift
      end
      string = ''
      (0..@height - 1).each do |y|
        (0..@width - 1).each do |x|
          string <<
            if asteroid_base == [x,y]
              '**'
            elsif @all_asteroids.include?([x,y])
              los = lines_of_sight.find {|line_params, aligned_asteroids| aligned_asteroids.include?([x,y])}
              if los
                show = display_values[los.first]
                base_index = los.last.index(asteroid_base)
                this_index = los.last.index([x,y])
                show.downcase! if (this_index - base_index).abs == 1
                show
              else
                '##'
              end
            else
              '..'
            end
          string << ' ' if x + 1 < @width
        end
        string << "\n"
      end
      string
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

    y_diff = asteroid2.last - asteroid1.last
    x_diff = asteroid2.first - asteroid1.first
    sign = (y_diff <=> 0) * (x_diff <=> 0)
    Rational("#{sign * y_diff.abs}/#{x_diff.abs}")
  end

  def maxsteroid
    @maxsteroid ||= @all_asteroids.max do |asteroid1, asteroid2|
      @memoized_asteroid_los_counts[asteroid1] <=> @memoized_asteroid_los_counts[asteroid2]
    end
  end
end

if __FILE__ == $0
  map = AsteroidMap.new(DATA.read)
  print "\nNumber of asteroids detected from best location (#{map.max_visibility_location}): #{map.max_visibility_count}\n\n"
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