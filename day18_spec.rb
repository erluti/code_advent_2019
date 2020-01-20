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
  end
end