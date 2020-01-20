require './day18.rb'
require 'rspec'

describe VaultMap do
  context 'Part 1' do
    it 'should find 8 steps for the first example' do
      map = <<~MAP_INPUT
        #########
        #b.A.@.a#
        #########
      MAP_INPUT
      vault = VaultMap.new(map)
      expect(vault.steps).to eq 8
    end

    it 'should find 86 steps for the second example' do
      map = <<~MAP_INPUT
        ########################
        #f.D.E.e.C.b.A.@.a.B.c.#
        ######################.#
        #d.....................#
        ########################
      MAP_INPUT
      vault = VaultMap.new(map)
      expect(vault.steps).to eq 86
    end

    it 'should find 132 steps for the third example' do
      map = <<~MAP_INPUT
        ########################
        #...............b.C.D.f#
        #.######################
        #.....@.a.B.c.d.A.e.F.g#
        ########################
      MAP_INPUT
      vault = VaultMap.new(map)
      expect(vault.steps).to eq 132
    end

    it 'should find 136 steps for the fourth example' do
      map = <<~MAP_INPUT
        #################
        #i.G..c...e..H.p#
        ########.########
        #j.A..b...f..D.o#
        ########@########
        #k.E..a...g..B.n#
        ########.########
        #l.F..d...h..C.m#
        #################
      MAP_INPUT
      vault = VaultMap.new(map)
      expect(vault.steps).to eq 136
    end

    it 'should find 81 steps for the fifth example' do
      map = <<~MAP_INPUT
        #################
        #i.G..c...e..H.p#
        ########.########
        #j.A..b...f..D.o#
        ########@########
        #k.E..a...g..B.n#
        ########.########
        #l.F..d...h..C.m#
        #################
      MAP_INPUT
      vault = VaultMap.new(map)
      expect(vault.steps).to eq 81
    end
  end
end