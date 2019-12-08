require './intcode_program.rb'

class ProgramSeries
  def initialize(program, phase_setting_sequence)
    @sequence = phase_setting_sequence
    @program = program
  end

  def run
    previous_output = 0
    @sequence.each do |input|
      program = IntcodeProgram.new(@program, input: [input, previous_output])
      program.run
      previous_output = program.output.first
    end
    previous_output
  end
end