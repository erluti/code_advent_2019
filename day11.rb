require './intcode/intcode_program.rb'

class PaintingRobot
  def initialize(intcode:,hullmap:)
    @hullmap = hullmap
    @position_x = 0
    @position_y = 0
    @direction = 0
    @panel_reader = IntcodeIO.new([current_panel.color])
    @actions = IntcodeIO.new
    @controller = IntcodeProgram.new(intcode, input:@panel_reader, output: @actions)
  end

  def current_panel
    @hullmap.panel(@position_x, @position_y)
  end

  def paint
    controller_thread = Thread.new { @controller.run }

    paint_color = read_action # first output is color
    current_panel.paint(paint_color)
    turn_direction = read_action # second output is turn direction
    @direction += turn_direction == 0 ? -90 : 90


    controller_thread.join
  end

  def read_action
    action = @actions.read
    if action.nil?
      sleep_count = 0
      while action.nil?
        raise "I don't think an action is coming!" if sleep_count >= 10
        sleep 0.001
        action = @actions.read
        sleep_count += 1
      end
    end
    action
  end
end

class HullMap
  def initialize
    @map = Hash.new {|hash, key| hash[key] = Panel.new }
  end

  def panel(x,y)
    @map[[x,y]]
  end

  def count_painted
    @map.values.count { |panel| panel.painted? }
  end
end

class Panel
  @attr_read :color
  def initialize
    @color = 0
    @painted = false
  end

  def paint(color)
    @painted = true
    @color = color
  end

  def painted?
    @painted
  end
end

if __FILE__ == $0
  intcode = DATA.readline
  map = HullMap.new
  robot = PaintingRobot.new(intcode: intcode, hullmap: map)
  robot.paint

  print "\nPainted #{map.count_painted} Panels\n\n"
end

__END__
3,8,1005,8,284,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,28,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,101,0,8,50,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,72,1006,0,24,1,1106,12,10,1006,0,96,1,1008,15,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,0,8,10,4,10,101,0,8,108,1006,0,54,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,101,0,8,134,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,155,1006,0,60,1006,0,64,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,183,1006,0,6,1006,0,62,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,1002,8,1,211,1,108,0,10,2,1002,15,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1001,8,0,242,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,263,101,1,9,9,1007,9,1010,10,1005,10,15,99,109,606,104,0,104,1,21101,0,666526126996,1,21101,301,0,0,1105,1,405,21101,846138811028,0,1,21101,312,0,0,1106,0,405,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21101,0,248129978391,1,21101,359,0,0,1105,1,405,21101,97751403560,0,1,21102,1,370,0,1106,0,405,3,10,104,0,104,0,3,10,104,0,104,0,21101,988753585000,0,1,21101,393,0,0,1105,1,405,21102,867961709324,1,1,21102,404,1,0,1106,0,405,99,109,2,22102,1,-1,1,21102,40,1,2,21101,436,0,3,21102,1,426,0,1105,1,469,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,431,432,447,4,0,1001,431,1,431,108,4,431,10,1006,10,463,1102,0,1,431,109,-2,2106,0,0,0,109,4,1202,-1,1,468,1207,-3,0,10,1006,10,486,21102,1,0,-3,22101,0,-3,1,21202,-2,1,2,21102,1,1,3,21101,505,0,0,1106,0,510,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,533,2207,-4,-2,10,1006,10,533,22101,0,-4,-4,1105,1,601,21201,-4,0,1,21201,-3,-1,2,21202,-2,2,3,21102,1,552,0,1105,1,510,21202,1,1,-4,21102,1,1,-1,2207,-4,-2,10,1006,10,571,21102,1,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,593,21202,-1,1,1,21102,1,593,0,106,0,468,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0
