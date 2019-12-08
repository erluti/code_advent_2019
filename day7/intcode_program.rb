require 'byebug'

class IntcodeProgram
  attr_reader :intcode
  attr_reader :output
  attr_reader :diagnostic_success

  def initialize(intcode, input:nil)
    @intcode = intcode.split(',').map(&:to_i) # AKA memory
    @input = input
    @output = []
  end

  def run
    position = 0 # aka instruction pointer
    opcode = @intcode[position]
    while operation(opcode) != 99
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
      else
        raise "#{opcode} not an opcode!"
      end
      position = jump_location || (position + instruction_length)
      opcode = @intcode[position]
    end
    # REVIEW do I need to test for diagnostic success?
    @intcode.join(',')
  end

  def read_input
    @input.shift
  end

  def operation(opcode)
    opcode % 100
  end

  def get_argument(position, opcode, argument_index)
    value_at(position + 1 + argument_index, parameter_mode(opcode, argument_index))
  end

  def parameter_mode(opcode, argument_index)
    arg_modifiers = opcode/100
    (1..argument_index).each do
      arg_modifiers /= 10
    end
    arg_modifiers % 10 == 1 ? :immediate : :position
  end

  def value_at(position, mode)
    if mode == :position
      value_by_pointer(position)
    else
      value(position)
    end
  end

  def value(position)
    @intcode[position]
  end

  def value_by_pointer(position)
    p = @intcode[position]
    @intcode[p]
  end

  def put_result(result, position, opcode, argument_index)
    write_at(result, position + 1 + argument_index, parameter_mode(opcode, argument_index))
  end

  def write_at(value, position, mode)
    location = position
    if mode == :position
      location = @intcode[position]
    end
    @intcode[location] = value
  end

  def output_value(value)
    @output << value
  end

  def prime_data(position:, value:)
    @intcode[position] = value
  end
end
