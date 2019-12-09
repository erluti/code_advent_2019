require './program_series.rb'
require 'rspec'

RSpec.configure do |c|
  c.filter_run_including :focus => true
end

describe ProgramSeries do
  it 'should return 43210 (from phase setting sequence 4,3,2,1,0) for 3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0' do
    series = ProgramSeries.new('3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0', [4,3,2,1,0])
    expect(series.run).to eq 43210
  end
  it 'should return 54321 (from phase setting sequence 0,1,2,3,4) for 3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0' do
    series = ProgramSeries.new('3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0', [0,1,2,3,4])
    expect(series.run).to eq 54321
  end
  it 'should return 65210 (from phase setting sequence 1,0,4,3,2) for 3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0' do
    series = ProgramSeries.new('3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0', [1,0,4,3,2])
    expect(series.run).to eq 65210
  end
  describe '.find_max_series' do
    it 'should return [4,3,2,1,0] for 3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0' do
      program = ProgramSeries.find_max_series('3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0')
      expect(program.sequence).to eq [4,3,2,1,0]
    end
    it 'should return [0,1,2,3,4] for 3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0' do
      program = ProgramSeries.find_max_series('3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0')
      expect(program.sequence).to eq [0,1,2,3,4]
    end
    it 'should return [1,0,4,3,2] for 3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0' do
      program = ProgramSeries.find_max_series('3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0')
      expect(program.sequence).to eq [1,0,4,3,2]
    end
  end
  describe 'with feedback loop' do
    describe 'example 1' do
      let(:program) { '3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5' }
      let(:sequence) { [9,8,7,6,5] }
      let(:value) { 139629729 }
      it "should return 139629729 with sequence [9,8,7,6,5]" do
        program_series = ProgramSeries.new(program, sequence)
        expect(program_series.run(true)).to eq value
      end
      it "should return [9,8,7,6,5] for .find_max_series" do
        # todo needs to be .find_max_feedback_loop_series
      end
    end

  end
end
