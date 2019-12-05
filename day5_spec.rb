require './day5.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe IntcodeProgram do
  context 'day2 tests' do
    it '1,0,0,0,99 becomes 2,0,0,0,99' do
      expect(IntcodeProgram.new('1,0,0,0,99').run).to eq '2,0,0,0,99'
    end
    it '2,3,0,3,99 becomes 2,3,0,6,99' do
      expect(IntcodeProgram.new('2,3,0,3,99').run).to eq '2,3,0,6,99'
    end
    it '2,4,4,5,99,0 becomes 2,4,4,5,99,9801' do
      expect(IntcodeProgram.new('2,4,4,5,99,0').run).to eq '2,4,4,5,99,9801'
    end
    it '1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99' do
      expect(IntcodeProgram.new('1,1,1,4,99,5,6,0,99').run).to eq '30,1,1,4,2,5,6,0,99'
    end
    it 'supports the day2 example' do
      expect(IntcodeProgram.new('1,9,10,3,2,3,11,0,99,30,40,50').run).to eq '3500,9,10,70,2,3,11,0,99,30,40,50'
    end
  end

  it 'can process complex opcodes' do
    expect(IntcodeProgram.new('1002,4,3,4,33').run).to eq '1002,4,3,4,99'
  end
  it 'supports negative values' do
    expect(IntcodeProgram.new('1101,100,-1,4,0').run).to eq '1101,100,-1,4,99'
  end
  it 'uses opcode 3 to read input' do
    # reads input into position 3, which is the first position paramter to an add, put the result in 0
    expect(IntcodeProgram.new('3,3,1,0,2,0,99', input:2).run).to eq '2,3,1,2,2,0,99'
  end
  it 'uses opcode 4 to produce output' do
    # outputs position 2 (the 99)
    subject = IntcodeProgram.new('4,2,99')
    subject.run
    expect(subject.output).to eq [99]
  end

  describe '#parameter_mode' do
    subject { IntcodeProgram.new('') }
    it 'should return :immediate for a 1' do
      expect(subject.parameter_mode(1003, 1)).to eq :immediate
    end
    it 'should return :position for a 0' do
      expect(subject.parameter_mode(10003, 1)).to eq :position
    end
  end
end