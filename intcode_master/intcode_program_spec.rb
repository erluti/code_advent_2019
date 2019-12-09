require_relative 'intcode_program.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe IntcodeProgram do
  describe '#read_input' do
    it 'raises error' do
      input = IntcodeIO.new
      subject = IntcodeProgram.new('99', input: input, sleep_max: 1)
      expect { subject.read_input }.to raise_error("I don't think a value is coming!")
    end
    it 'can handle a delay in input' do
      input = IntcodeIO.new
      subject = IntcodeProgram.new('99', input: input, sleep_max: 1)
      t = Thread.new do
        x = subject.read_input
        subject.output_value(x)
      end
      input_value = '123'
      input.write(input_value)
      t.join
      expect(subject.output).to eq [input_value]
    end
  end

  context 'day7 updates' do
    it 'can read two inputs' do
      program = '3,5,3,6,1101,0,0,7,99'
      input1, input2 = 4, 5
      expect(IntcodeProgram.new(program, input: IntcodeIO.new([input1, input2])).run).to eq "3,5,3,6,1101,#{input1},#{input2},#{input1 + input2},99"
    end
  end

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

  context 'day5 part 1 tests' do
    it 'can process complex opcodes' do
      expect(IntcodeProgram.new('1002,4,3,4,33').run).to eq '1002,4,3,4,99'
    end
    it 'supports negative values' do
      expect(IntcodeProgram.new('1101,100,-1,4,0').run).to eq '1101,100,-1,4,99'
    end
    it 'uses opcode 3 to read input' do
      # reads input into position 3, which is the first position paramter to an add, put the result in 0
      expect(IntcodeProgram.new('3,3,1,0,2,0,99', input: IntcodeIO.new([2])).run).to eq '2,3,1,2,2,0,99'
    end
    it 'uses opcode 4 to produce output' do
      # outputs position 2 (the 99)
      subject = IntcodeProgram.new('4,2,99')
      subject.run
      expect(subject.output).to eq [99]
    end
  end

  context 'day5 part 2 tests' do
    describe '"equal to 8" program' do
      let(:program) { '3,9,8,9,10,9,4,9,99,-1,8' }
      it 'should output 1 when input is 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([8]))
        subject.run
        expect(subject.output.first).to eq 1
      end
      it 'should output 0 when input is greater than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([354]))
        subject.run
        expect(subject.output.first).to eq 0
      end
      it 'should output 0 when input is less than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([2]))
        subject.run
        expect(subject.output.first).to eq 0
      end
    end

    describe '"less than 8" program' do
      let(:program) { '3,9,7,9,10,9,4,9,99,-1,8' }
      it 'should output 1 when input less than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([4]))
        subject.run
        expect(subject.output.first).to eq 1
      end
      it 'should output 0 when input is greater than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([354]))
        subject.run
        expect(subject.output.first).to eq 0
      end
      it 'should output 0 when input is equal to 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([8]))
        subject.run
        expect(subject.output.first).to eq 0
      end
    end

    describe '"equal to 8 (immediate)" program' do
      let(:program) { '3,3,1108,-1,8,3,4,3,99' }
      it 'should output 1 when input is 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([8]))
        subject.run
        expect(subject.output.first).to eq 1
      end
      it 'should output 0 when input is greater than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([354]))
        subject.run
        expect(subject.output.first).to eq 0
      end
      it 'should output 0 when input is less than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([2]))
        subject.run
        expect(subject.output.first).to eq 0
      end
    end

    describe '"less than 8 (immediate)" program' do
      let(:program) { '3,3,1107,-1,8,3,4,3,99' }
      it 'should output 1 when input less than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([4]))
        subject.run
        expect(subject.output.first).to eq 1
      end
      it 'should output 0 when input is greater than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([354]))
        subject.run
        expect(subject.output.first).to eq 0
      end
      it 'should output 0 when input is equal to 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([8]))
        subject.run
        expect(subject.output.first).to eq 0
      end
    end

    describe '"test non-zero" program' do
      let(:program) { '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9' }
      it 'should output 0 when input is 0' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([0]))
        subject.run
        expect(subject.output.first).to eq 0
      end
      it 'should output 1 when input is greater than 0' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([354]))
        subject.run
        expect(subject.output.first).to eq 1
      end
      it 'should output 1 when input is less than 0' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([-2]))
        subject.run
        expect(subject.output.first).to eq 1
      end
    end

    describe '"test non-zero (immediate)" program' do
      let(:program) { '3,3,1105,-1,9,1101,0,0,12,4,12,99,1' }
      it 'should output 0 when input is 0' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([0]))
        subject.run
        expect(subject.output.first).to eq 0
      end
      it 'should output 1 when input is greater than 0' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([100]))
        subject.run
        expect(subject.output.first).to eq 1
      end
      it 'should output 1 when input is less than 0' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([-20]))
        subject.run
        expect(subject.output.first).to eq 1
      end
    end

    describe 'larger example program' do
      let(:program) { '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99' }
      it 'should output 1000 when input is 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([8]))
        subject.run
        expect(subject.output.first).to eq 1000
      end
      it 'should output 1001 when input is greater than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([3534]))
        subject.run
        expect(subject.output.first).to eq 1001
      end
      it 'should output 999 when input is less than 8' do
        subject = IntcodeProgram.new(program, input: IntcodeIO.new([5]))
        subject.run
        expect(subject.output.first).to eq 999
      end
    end
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
