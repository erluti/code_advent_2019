require_relative 'intcode_io.rb'
require 'byebug'

class IntcodeProgram
  attr_reader :intcode

  def initialize(intcode, input:nil, output: IntcodeIO.new, sleep_max: 10)
    @sleep_max = sleep_max.freeze
    @intcode = intcode.split(',').map(&:to_i) # AKA memory
    @input, @output = input, output
    @relative_base = 0

    @instruction_pointer = 0
    @halted = false
  end

  def output
    @output.values
  end

  def run_next_instruction
    position = @instruction_pointer
    opcode = @intcode[position]
    instruction_length = 0
    jump_location = nil
    case operation(opcode)
    when 1 # add
      v1 = get_argument(position, opcode, 0)
      v2 = get_argument(position, opcode, 1)
      put_result(v1 + v2, position, opcode, 2)
      instruction_length = 4
    when 2 # multiply
      v1 = get_argument(position, opcode, 0)
      v2 = get_argument(position, opcode, 1)
      put_result(v1 * v2, position, opcode, 2)
      instruction_length = 4
    when 3 # input
      put_result(read_input, position, opcode, 0)
      instruction_length = 2
    when 4 # output
      value = get_argument(position, opcode, 0)
      output_value(value)
      instruction_length = 2
    when 5 # jump-if-true
      value = get_argument(position, opcode, 0)
      if value != 0
        jump_location = get_argument(position, opcode, 1)
      end
      instruction_length = 3
    when 6 # jump-if-false
      value = get_argument(position, opcode, 0)
      if value == 0
        jump_location = get_argument(position, opcode, 1)
      end
      instruction_length = 3
    when 7 # less than
      v1 = get_argument(position, opcode, 0)
      v2 = get_argument(position, opcode, 1)
      result = (v1 < v2 ? 1 : 0)
      put_result(result, position, opcode, 2)
      instruction_length = 4
    when 8 # equals
      v1 = get_argument(position, opcode, 0)
      v2 = get_argument(position, opcode, 1)
      result = (v1 == v2 ? 1 : 0)
      put_result(result, position, opcode, 2)
      instruction_length = 4
    when 9 #adjust relative base
      base_adjustment = get_argument(position, opcode, 0)
      @relative_base += base_adjustment
      instruction_length = 2
    when 99
      @halted = true
    else
      raise "#{opcode} not an opcode!"
    end
    @instruction_pointer = jump_location || (position + instruction_length)
  end

  def run
    run_next_instruction unless @halted
    while running
      run_next_instruction
    end
    @intcode.join(',')
  end

  def running
    !@halted
  end

  def read_input
    input_value = @input.read
    if input_value.nil?
      sleep_count = 0
      while input_value.nil?
        raise "I don't think a value is coming!" if sleep_count >= @sleep_max
        sleep 0.001
        input_value = @input.read
        sleep_count += 1
      end
    end
    input_value
  end

  def operation(opcode)
    opcode % 100
  end

  def get_argument(position, opcode, argument_index)
    value_at(position + 1 + argument_index, parameter_mode(opcode, argument_index))
  end

  def put_result(result, position, opcode, argument_index)
    write_at(result, position + 1 + argument_index, parameter_mode(opcode, argument_index))
  end

  def parameter_mode(opcode, argument_index)
    arg_modifiers = opcode/100
    (1..argument_index).each do
      arg_modifiers /= 10
    end
    case arg_modifiers % 10
    when 0
      :position
    when 1
      :immediate
    when 2
      :relative
    else
      raise "Parameter mode not found! opcode: #{opcode} argument_index: #{argument_index}"
    end
  end

  def value_at(position, mode)
    location = location(position, mode)
    right_size_array(location)
    @intcode[location]
  end


  def write_at(value, position, mode)
    location = location(position, mode)
    right_size_array(location)
    @intcode[location] = value
  end

  def location(position, mode)
    case mode
    when :position
      @intcode[position]
    when :relative
      @intcode[position] + @relative_base
    when :immediate
      position
    end
  end

  def right_size_array(index)
    if index > @intcode.length
      @intcode += Array.new(index - @intcode.length + 1, 0)
    end
  end

  def output_value(value)
    @output.write(value)
  end

  # inserts values into a loaded program (before a run)
  def prime_data(position:, value:)
    @intcode[position] = value
  end
end
