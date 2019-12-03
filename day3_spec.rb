require './day3.rb'
require 'rspec'

describe Wire do
  describe '#intersect' do
    it 'R8,U5,L5,D3 and U7,R6,D4,L4' do
      expect(Wire.new('R8,U5,L5,D3').intersect(Wire.new('U7,R6,D4,L4'))).to eq 6
    end
    it 'R75,D30,R83,U83,L12,D49,R71,U7,L72 and U62,R66,U55,R34,D71,R55,D58,R83' do
      expect(Wire.new('R75,D30,R83,U83,L12,D49,R71,U7,L72').intersect(Wire.new('U62,R66,U55,R34,D71,R55,D58,R83'))).to eq 159
    end
    it 'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51 and U98,R91,D20,R16,D67,R40,U7,R15,U6,R7' do
      expect(Wire.new('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51').intersect(Wire.new('U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'))).to eq 135
    end
  end

  describe '#intersect_minimum_signal_delay' do
    it 'R8,U5,L5,D3 and U7,R6,D4,L4' do
      expect(Wire.new('R8,U5,L5,D3').intersect_minimum_signal_delay(Wire.new('U7,R6,D4,L4'))).to eq 30
    end
    it 'R75,D30,R83,U83,L12,D49,R71,U7,L72 and U62,R66,U55,R34,D71,R55,D58,R83' do
      expect(Wire.new('R75,D30,R83,U83,L12,D49,R71,U7,L72').intersect_minimum_signal_delay(Wire.new('U62,R66,U55,R34,D71,R55,D58,R83'))).to eq 610
    end
    it 'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51 and U98,R91,D20,R16,D67,R40,U7,R15,U6,R7' do
      expect(Wire.new('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51').intersect_minimum_signal_delay(Wire.new('U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'))).to eq 410
    end
  end
end
