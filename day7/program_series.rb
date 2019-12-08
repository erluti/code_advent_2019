require './intcode_program.rb'

class ProgramSeries
  attr_reader :sequence, :program
  def initialize(program, phase_setting_sequence)
    @sequence = phase_setting_sequence
    @program = program
  end

  def run
    previous_output = 0
    @sequence.each do |input|
      program = IntcodeProgram.new(@program, input: IntcodeIO.new([input, previous_output]))
      program.run
      previous_output = program.output.first
    end
    previous_output
  end

  def self.find_max_series(program)
    possible_inputs = [1,2,3,4,0]
    max_output = 0
    best_program = nil

    possible_inputs.each do |first_input|
      (possible_inputs - [first_input]).each do |second_input|
        (possible_inputs - [first_input, second_input]).each do |third_input|
          (possible_inputs - [first_input, second_input, third_input]).each do |fourth_input|
            fifth_input = (possible_inputs - [first_input, second_input, third_input, fourth_input]).first
            inputs = [first_input, second_input, third_input, fourth_input, fifth_input]
            program_series = ProgramSeries.new(program, inputs)
            result = program_series.run
            if result > max_output
              max_output = result
              best_program = program_series
            end
          end
        end
      end
    end
    best_program
  end

end
