require './day12.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe OrbitalSystem do
  describe 'first example' do
    let(:moon1) { Moon.new_from_string('<x=-1, y=0, z=2>') }
    let(:moon2) { Moon.new_from_string('<x=2, y=-10, z=-7>') }
    let(:moon3) { Moon.new_from_string('<x=4, y=-8, z=8>') }
    let(:moon4) { Moon.new_from_string('<x=3, y=5, z=-1>') }
    subject { OrbitalSystem.new([moon1, moon2, moon3, moon4]) }
    describe 'After 1 step' do
      before { subject.step }
      it 'should have moon1 at [2,-1,1]' do
        expect(moon1.coordinates).to eq [2,-1,1]
      end
      it 'should have moon1 with velocity [3,-1,-1]' do
        expect(moon1.coordinates).to eq [3,-1,-1]
      end
      it 'should have moon2 at [3,-7,-4]' do
        expect(moon2.coordinates).to eq [3,-7,-4]
      end
      it 'should have moon2 with velocity [1,3,3]' do
        expect(moon2.coordinates).to eq [1,3,3]
      end
      it 'should have moon3 at [1,-7,5]' do
        expect(moon3.coordinates).to eq [1,-7,5]
      end
      it 'should have moon3 with velocity [-3,1,-3]' do
        expect(moon3.coordinates).to eq [-3,1,-3]
      end
      it 'should have moon4 at [2,2,0]' do
        expect(moon4.coordinates).to eq [2,2,0]
      end
      it 'should have moon4 with velocity [-1,-3,1]' do
        expect(moon4.coordinates).to eq [-1,-3,1]
      end
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