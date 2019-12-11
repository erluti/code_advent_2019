require './day10.rb'
require 'rspec'

describe AsteroidMap do
  describe 'example 1' do
    let(:example_input) do
      <<~MAP
        .#..#
        .....
        #####
        ....#
        ...##
      MAP
    end
    subject { AsteroidMap.new(example_input) }
    it 'should find 8 as the highest visibility count' do
      expect(subject.max_visibility_count).to eq 8
    end
    it 'should find 3,4 as the highest visibility location' do
      expect(subject.max_visibility_location).to eq [3,4]
    end
  end
  describe 'example 2' do
    let(:example_input) do
      <<~MAP
        ......#.#.
        #..#.#....
        ..#######.
        .#.#.###..
        .#..#.....
        ..#....#.#
        #..#....#.
        .##.#..###
        ##...#..#.
        .#....####
      MAP
    end
    subject { AsteroidMap.new(example_input) }
    it 'should find 33 as the highest visibility count' do
      expect(subject.max_visibility_count).to eq 33
    end
    it 'should find 5,8 as the highest visibility location' do
      expect(subject.max_visibility_location).to eq [5,8]
    end
  end
  describe 'example 3' do
    let(:example_input) do
      <<~MAP
        #.#...#.#.
        .###....#.
        .#....#...
        ##.#.#.#.#
        ....#.#.#.
        .##..###.#
        ..#...##..
        ..##....##
        ......#...
        .####.###.
      MAP
    end
    subject { AsteroidMap.new(example_input) }
    it 'should find 35 as the highest visibility count' do
      expect(subject.max_visibility_count).to eq 35
    end
    it 'should find 1,2 as the highest visibility location' do
      expect(subject.max_visibility_location).to eq [1,2]
    end
  end
  describe 'example 4' do
    let(:example_input) do
      <<~MAP
        .#..#..###
        ####.###.#
        ....###.#.
        ..###.##.#
        ##.##.#.#.
        ....###..#
        ..#.#..#.#
        #..#.#.###
        .##...##.#
        .....#.#..
      MAP
    end
    subject { AsteroidMap.new(example_input) }
    it 'should find 41 as the highest visibility count' do
      expect(subject.max_visibility_count).to eq 41
    end
    it 'should find 6,3 as the highest visibility location' do
      expect(subject.max_visibility_location).to eq [6,3]
    end
  end
  describe 'example 5' do
    let(:example_input) do
      <<~MAP
        .#..##.###...#######
        ##.############..##.
        .#.######.########.#
        .###.#######.####.#.
        #####.##.#.##.###.##
        ..#####..#.#########
        ####################
        #.####....###.#.#.##
        ##.#################
        #####.##.###..####..
        ..######..##.#######
        ####.##.####...##..#
        .#####..#.######.###
        ##...#.##########...
        #.##########.#######
        .####.#.###.###.#.##
        ....##.##.###..#####
        .#.#.###########.###
        #.#.#.#####.####.###
        ###.##.####.##.#..##
      MAP
    end
    subject { AsteroidMap.new(example_input) }
    it 'should find 210 as the highest visibility count' do
      expect(subject.max_visibility_count).to eq 210
    end
    it 'should find 11,13 as the highest visibility location' do
      expect(subject.max_visibility_location).to eq [11,13]
    end
  end
end