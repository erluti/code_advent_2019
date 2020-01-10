require './day17.rb'
require 'rspec'

describe CameraView do
  context 'part 1 - example input' do
    subject do
      view = [
        46,46,35,46,46,46,46,46,46,46,46,46,46,10,
        46,46,35,46,46,46,46,46,46,46,46,46,46,10,
        35,35,35,35,35,35,35,46,46,46,35,35,35,10,
        35,46,35,46,46,46,35,46,46,46,35,46,35,10,
        35,35,35,35,35,35,35,35,35,35,35,35,35,10,
        46,46,35,46,46,46,35,46,46,46,35,46,46,10,
        46,46,35,35,35,35,35,46,46,46,94,46,46
      ]
      CameraView.new(view)
    end
    describe '#intersections' do
      it 'should find four intersections' do
        expect(subject.intersections.count).to eq 4
      end
      it 'should include [2,2], [2,4], [6,4], [10,4]' do
        expect(subject.intersections).to include([2,2], [2,4], [6,4], [10,4])
      end
    end
    describe '#alignment_parameters_sum' do
      it 'should equal 76' do
        expect(subject.alignment_parameters_sum).to eq 76
      end
    end
  end
end