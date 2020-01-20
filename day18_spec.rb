require './day18.rb'
require 'rspec'

describe VaultMap do
  context 'Part 1' do
    context 'example the first' do
      subject do
        map = <<~MAP_INPUT
          #########
          #b.A.@.a#
          #########
        MAP_INPUT
        VaultMap.new(map)
      end
      it 'should find 8 steps' do
        expect(subject.steps).to eq 8
      end
      it 'should have keys a and b' do
        expect(subject.keys).to eq %w(a b)
      end
      it 'should have start at 5,1' do
        expect(subject.start).to eq [5,1]
      end
    end

    context 'example the second' do
      subject do
        map = <<~MAP_INPUT
          ########################
          #f.D.E.e.C.b.A.@.a.B.c.#
          ######################.#
          #d.....................#
          ########################
        MAP_INPUT
        VaultMap.new(map)
      end
      it 'should have keys a-f' do
        expect(subject.keys).to eq %w(a b c d e f)
      end
      it 'should find 86 steps' do
        expect(subject.steps).to eq 86
      end
    end

    context 'example the third' do
      subject do
        map = <<~MAP_INPUT
          ########################
          #...............b.C.D.f#
          #.######################
          #.....@.a.B.c.d.A.e.F.g#
          ########################
        MAP_INPUT
        VaultMap.new(map)
      end
      it 'should have keys a-g' do
        expect(subject.keys).to eq %w(a b c d e f g)
      end
      it 'should find 132 steps' do
        expect(subject.steps).to eq 132
      end
    end

    context 'example the fourth' do
      subject do
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
        VaultMap.new(map)
      end
      it 'should have keys a-o' do
        expect(subject.keys).to eq %w(a b c d e f g h i j k l m n o p)
      end
      it 'should find 136 steps' do
        expect(subject.steps).to eq 136
      end
    end

    context 'example the fifth' do
      subject do
        map = <<~MAP_INPUT
          ########################
          #@..............ac.GI.b#
          ###d#e#f################
          ###A#B#C################
          ###g#h#i################
          ########################
        MAP_INPUT
        VaultMap.new(map)
      end
      it 'should have keys a-h' do
        expect(subject.keys).to eq %w(a b c d e f g h i)
      end
      it 'should find 81 steps' do
        expect(subject.steps).to eq 81
      end
    end
  end
end