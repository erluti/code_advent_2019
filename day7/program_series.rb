require './intcode_program.rb'

class ProgramSeries
  attr_reader :sequence, :program
  def initialize(program, phase_setting_sequence)
    @sequence = phase_setting_sequence
    @program = program
  end

  def run(feedback_loop = false)
    sequence = @sequence.dup
    initial_input = IntcodeIO.new([sequence.shift, 0])
    next_input = IntcodeIO.new([sequence.shift])
    programs = [IntcodeProgram.new(@program, output: next_input, input: initial_input)]
    sequence.each do |phase_setting|
      input = next_input
      next_input = IntcodeIO.new([phase_setting])
      programs << IntcodeProgram.new(@program, output: next_input, input: input)
    end
    last_program =
      if feedback_loop
        IntcodeProgram.new(@program, input: next_input, output: initial_input)
      else
        IntcodeProgram.new(@program, input: next_input)
      end
    programs << last_program

    programs.collect do |program|
      Thread.new { program.run }
    end.map(&:join)
    last_program.output.first
  end

  # def run
  #   previous_output = 0
  #   @sequence.each do |input|
  #     program = IntcodeProgram.new(@program, input: IntcodeIO.new([input, previous_output]))
  #     program.run
  #     previous_output = program.output.first
  #   end
  #   previous_output
  # end

  def self.find_max_series(program, feedback_loop: false)
    possible_inputs =
      if feedback_loop
        [9,8,7,6,5]
      else
        [1,2,3,4,0]
      end
    max_output = 0
    best_program = nil

    possible_inputs.each do |first_input|
      (possible_inputs - [first_input]).each do |second_input|
        (possible_inputs - [first_input, second_input]).each do |third_input|
          (possible_inputs - [first_input, second_input, third_input]).each do |fourth_input|
            fifth_input = (possible_inputs - [first_input, second_input, third_input, fourth_input]).first
            inputs = [first_input, second_input, third_input, fourth_input, fifth_input]
            program_series = ProgramSeries.new(program, inputs)
            result = program_series.run(feedback_loop)
            if result > max_output
              # p "New best program sequence: #{program_series.sequence}"
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
