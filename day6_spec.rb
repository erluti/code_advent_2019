require './day6.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

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
    describe '.connect_orbits' do
      subject { Orbiter.connect_orbits(example_map) }
      it 'should should return a hash of connected Orbiters' do
        expect(subject['COM'].orbiting).to be_nil
        expect(subject['COM'].orbiters).to eq [subject['B']]
        expect(subject['COM'].orbiters).to eq [subject['B']]
      end
    end
  end

end
