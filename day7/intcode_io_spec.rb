require './intcode_io.rb'
require 'rspec'

describe IntcodeIO do
  describe '#read' do
    it 'should return FIFO elements' do
      subject = IntcodeIO.new([1,2])
      expect(subject.read).to eq 1
      expect(subject.read).to eq 2
      expect(subject.read).to eq nil
    end
  end
  describe '#write' do
    it 'should add element to values' do
      subject = IntcodeIO.new
      subject.write(88)
      expect(subject.values).to eq [88]
    end
    it 'should append elements' do
      subject = IntcodeIO.new
      subject.write(77)
      subject.write(99)
      expect(subject.values).to eq [77, 99]
    end
  end
end
