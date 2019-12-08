require './day8.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe 'part 1 sample sequence' do
  let(:test_input) { '123456789012' }
  describe SpaceImageFormat do
    subject { SpaceImageFormat.new(height: 2, width: 3, sequence: test_input) }
    it 'should create two layers in a 3x2' do
      expect(subject.layers.count).to eq 2
    end
    it 'can fidn the layer with the most 0s' do
      expect(subject.layer_with_most('0').sequence).to eq '789012'
    end
  end
  describe Layer do
    let(:height) { 2 }
    let(:width) { 3 }
    subject { Layer.new(height: height, width: width, sequence: test_input[0..5]) }
    it 'should have [height] rows' do
      expect(subject.rows.count).to eq height
    end
    describe '#count' do
      it 'should return 1 for "2"' do
        expect(subject.count('2')).to eq 1
      end
      it 'should return 0 for "8"' do
        expect(subject.count('8')).to eq 0
      end
    end
  end
end

describe SpaceImageFormat do
  it 'should be able to find a layer with the most zeros for height 1' do
    subject = SpaceImageFormat.new(height: 1, width: 2, sequence: '0012010211')
    expect(subject.layer_with_most('0').sequence).to eq '00'
  end
  it 'should be able to find a layer with the most zeros for width 1' do
    subject = SpaceImageFormat.new(height: 3, width: 1, sequence: '000120102011')
    expect(subject.layer_with_most('0').sequence).to eq '000'
  end
end