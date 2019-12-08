require './program_series.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

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
end
