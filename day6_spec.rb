require './day6.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe OrbitMap do
  describe 'part 2 - example map' do
    let(:example_map2) do
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
        K)YOU
        I)SAN
      MAP
    end

    subject { OrbitMap.connect_orbits(example_map2) }
    describe '#move_node'
    describe '#join_orbit' do
      it "should add child to a parent's parent" do
        subject.join_orbit(subject['H'],subject['B'])
        expect(subject['H'].orbiting).to eq subject['B']
        expect(subject['G'].orbiters).to be_empty
        expect(subject['B'].orbiters).to include(subject['H'], subject['G'])
      end
      it 'should make a sibling into a child' do
        subject.join_orbit(subject['I'], subject['E'])
        expect(subject['I'].orbiting).to eq subject['E']
        expect(subject['D'].orbiters).to eq [subject['E']]
        expect(subject['E'].orbiters).to include(subject['I'], subject['J'], subject['F'])
      end
    end
  end

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
      it 'should should return a hash of connected Orbiters' do
        map = OrbitMap.connect_orbits(example_map)
        expect(map['COM'].orbiting).to be_nil
        expect(map['COM'].orbiters).to eq [map['B']]
        expect(map['B'].orbiters).to eq [map['C'], map['G']]
        expect(map['G'].orbiters).to eq [map['H']]
        expect(map['H'].orbiters).to eq []
        expect(map['C'].orbiters).to eq [map['D']]
        expect(map['D'].orbiters).to eq [map['E'], map['I']]
        expect(map['I'].orbiters).to eq []
        expect(map['E'].orbiters).to eq [map['F'], map['J']]
        expect(map['F'].orbiters).to eq []
        expect(map['J'].orbiters).to eq [map['K']]
        expect(map['K'].orbiters).to eq [map['L']]
        expect(map['L'].orbiters).to eq []
      end
    end

    describe '#read_connection' do
      it 'should accept each line of the example map' do
        subject = OrbitMap.new
        reader = StringIO.new(example_map)
        reader.each_line do |entry|
          subject.read_connection(entry)
        end
        expect(subject.keys).to match ['COM'] + ('B'..'L').to_a
      end
    end

    describe '#total_orbits' do
      subject { OrbitMap.connect_orbits(example_map) }
      it 'should equal 42' do
        expect(subject.total_orbits).to eq 42
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

    context 'part 2 -' do
      describe '#path_to_COM' do
        let(:orbit_map) { OrbitMap.connect_orbits(example_map) }
        it 'should be ["COM"] for COM' do
          expect(orbit_map['COM'].path_to_COM).to eq ["COM"]
        end
        it 'should be ["H", "G", "B", "COM"] for H' do
          expect(orbit_map['H'].path_to_COM).to eq ["H", "G", "B", "COM"]
        end
      end
    end
  end

end
