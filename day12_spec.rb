require './day12.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe OrbitalSystem do
  describe 'first example' do
    subject do
      moons = []
      moons << Moon.new_from_string('<x=-1, y=0, z=2>')
      moons << Moon.new_from_string('<x=2, y=-10, z=-7>')
      moons << Moon.new_from_string('<x=4, y=-8, z=8>')
      moons << Moon.new_from_string('<x=3, y=5, z=-1>')
      OrbitalSystem.new(moons)
    end
    it 'should have a total energy of 179 after 10 steps' do
      10.times { subject.step }
      expect(subject.system_energy).to eq 179
    end
  end
end

describe Moon do
  describe '#total_energy' do
    subject { Moon.new(1,1,1) }
    it 'should return 0 with no velocity' do
      expect(subject.total_energy).to eq 0
    end
    it 'should return 6 after applying gravity of a moon on (5,2,-5)' do
      subject.apply_gravity(Moon.new(5,2,-5))
      # velocity = -1,-1,1
      subject.step
      expect(subject.total_energy).to eq 6
    end
    it 'should return 48 after applying gravity of a moon on (5,2,-5) twice' do
      subject.apply_gravity(Moon.new(5,2,-5))
      # velocity = -1,-1,1
      subject.step
      # position 0,0,2
      subject.apply_gravity(Moon.new(5,2,-5))
      # velocity = -2,-2,2
      subject.step
      # position -2,-2,4
      expect(subject.total_energy).to eq 48
    end
    it 'should return 15 after stepping through applying gravity of two moons' do
      subject.apply_gravity(Moon.new(5,2,-5))
      # velocity = -1,-1,1
      subject.step
      # position 0,0,2
      subject.apply_gravity(Moon.new(-1,0,1))
      # velocity = 0,-1,2
      subject.step
      # position 0,0,5
      expect(subject.total_energy).to eq 15
    end
  end
end