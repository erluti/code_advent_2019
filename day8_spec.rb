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
    it 'can find the layer with the most 0s' do
      expect(subject.layer_with_most('0').sequence).to eq '789012'
    end
    it 'can find the layer with the least 0s' do
      expect(subject.layer_with_least('0').sequence).to eq '123456'
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

  it 'should be able to find a layer with the least zeros for height 1' do
    subject = SpaceImageFormat.new(height: 1, width: 2, sequence: '00020111')
    expect(subject.layer_with_least('0').sequence).to eq '11'
  end
  it 'should be able to find a layer with the least zeros for width 1' do
    subject = SpaceImageFormat.new(height: 3, width: 1, sequence: '000120102111')
    expect(subject.layer_with_least('0').sequence).to eq '111'
  end

  describe '#render' do
    it 'should return a String' do
      subject = SpaceImageFormat.new(height: 2, width: 2, sequence: '11110000')
      expect(subject.render).to be_a String
    end
    it 'should display values "underneath" transparent ones' do
      subject = SpaceImageFormat.new(height: 2, width: 2, sequence: '22221100')
      expect(subject.render).to eq "11\n00\n"
    end
    it 'should not display values "underneath" opaque ones' do
      subject = SpaceImageFormat.new(height: 2, width: 2, sequence: '00001111')
      expect(subject.render).to eq "00\n00\n"
    end
    describe 'part 2 example' do
      subject { SpaceImageFormat.new(height: 2, width: 2, sequence: '0222112222120000') }
      it 'should return 01 10' do
        expect(subject.render).to eq "01\n10\n"
      end
    end
  end
end

describe Layer do
  describe '#display' do
    it 'should be a string with linebreaks' do
      subject = Layer.new(height: 2, width: 2, sequence: '0112')
      expect(subject.display).to eq "01\n12\n"
    end
  end
end