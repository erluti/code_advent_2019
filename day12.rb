require 'byebug'

class Moon
  def self.new_from_string(string)
    parts = string.gsub(/<|>| |(x|y|z)=/, '').split(',').map(&:to_i)
    Moon.new(*parts)
  end

  attr_reader :x, :y, :z

  def coordinates
    [@x, @y, @z]
  end

  def velocities
    [@vx, @vy, @vz]
  end

  def initialize(x,y,z)
    @x, @y, @z = x,y,z
    @vx, @vy, @vz = 0,0,0
    @delta_vx, @delta_vy, @delta_vz = 0,0,0
  end

  def apply_gravity(moon)
    # if my coordinate is lower, I need +1
    @delta_vx += -(@x <=> moon.x)
    @delta_vy += -(@y <=> moon.y)
    @delta_vz += -(@z <=> moon.z)
  end

  def step
    @vx += @delta_vx
    @vy += @delta_vy
    @vz += @delta_vz
    @delta_vx, @delta_vy, @delta_vz = 0,0,0
    @x += @vx
    @y += @vy
    @z += @vz
  end

  def total_energy
    (@x.abs + @y.abs + @z.abs) * (@vx.abs + @vy.abs + @vz.abs)
  end
end

class OrbitalSystem
  def initialize(moons)
    @moons = moons
  end

  def step
    @moons.each do |moon|
      (@moons - [moon]).each do |other_moon|
        moon.apply_gravity(other_moon)
      end
    end
    @moons.map(&:step)
  end

  def system_energy
    @moons.map(&:total_energy).sum
  end
end

if __FILE__ == $0
  moons = []
  DATA.read.split("\n").each do |moon_data|
    moons << Moon.new_from_string(moon_data)
  end
  orbital_system = OrbitalSystem.new(moons)
  1000.times { orbital_system.step }
  print "System Energy after 1000 steps: #{orbital_system.system_energy}\n\n"
end

__END__
<x=12, y=0, z=-15>
<x=-8, y=-5, z=-10>
<x=7, y=-17, z=1>
<x=2, y=-11, z=-6>
