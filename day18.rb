require 'byebug'

class VaultMap
  def initialize(text)
    @map = Hash.new { |h,k| h[k] = [] }
    text.split("\n").each_with_index do |row, i|
      @map[i] = row.split('')
    end
  end

  def steps
    0
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