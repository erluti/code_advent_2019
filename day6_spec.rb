require './day6.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe OrbitMap do
  describe 'example map' do
    let(:example_map) do
      <<~MAP
        COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
      MAP
    end

    describe '.connect_orbits' do
      subject { OrbitMap.connect_orbits(example_map) }
      it 'should should return a hash of connected Orbiters' do
        expect(subject['COM'].orbiting).to be_nil
        expect(subject['COM'].orbiters).to eq [subject['B']]
        expect(subject['B'].orbiters).to eq [subject['C'], subject['G']]
        expect(subject['G'].orbiters).to eq [subject['H']]
        expect(subject['H'].orbiters).to eq []
        expect(subject['C'].orbiters).to eq [subject['D']]
        expect(subject['D'].orbiters).to eq [subject['E'], subject['I']]
        expect(subject['I'].orbiters).to eq []
        expect(subject['E'].orbiters).to eq [subject['F'], subject['J']]
        expect(subject['F'].orbiters).to eq []
        expect(subject['J'].orbiters).to eq [subject['K']]
        expect(subject['K'].orbiters).to eq [subject['L']]
        expect(subject['L'].orbiters).to eq []
      end
    end
  end
end

describe Orbiter do
  describe 'example map' do
    let(:example_map) do
      <<~MAP
        COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
      MAP
    end

    describe '#distance_from_COM' do
      let(:orbits) { OrbitMap.connect_orbits(example_map) }
      it 'should be 3 for example orbit D' do
        expect(orbits['D'].distance_from_COM).to eq 3
      end
      it 'should be 7 for example orbit L' do
        expect(orbits['L'].distance_from_COM).to eq 7
      end
      it 'should be 0 for Center Of Mass (COM)' do
        expect(orbits['COM'].distance_from_COM).to eq 0
      end
    end
  end

end
