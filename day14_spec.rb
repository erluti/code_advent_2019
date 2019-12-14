require './day14.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe NanoFactory do
  context 'example 1' do
    let(:reactions) do
      <<~REACTIONS
        10 ORE => 10 A
        1 ORE => 1 B
        7 A, 1 B => 1 C
        7 A, 1 C => 1 D
        7 A, 1 D => 1 E
        7 A, 1 E => 1 FUEL
      REACTIONS
    end
    subject { NanoFactory.new(reactions) }
    it 'should require 31 ORE for 1 FUEL' do
      expect(subject.ore_required).to eq 31
    end
  end

  context 'example 2' do
    let(:reactions) do
      <<~REACTIONS
        9 ORE => 2 A
        8 ORE => 3 B
        7 ORE => 5 C
        3 A, 4 B => 1 AB
        5 B, 7 C => 1 BC
        4 C, 1 A => 1 CA
        2 AB, 3 BC, 4 CA => 1 FUEL
      REACTIONS
    end
    subject { NanoFactory.new(reactions) }
    it 'should require 165 ORE for 1 FUEL' do
      expect(subject.ore_required).to eq 165
    end
  end

end