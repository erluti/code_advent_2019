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
      case operation(opcode)
      when 1
        v1 = get_argument(position, opcode, 0)
        v2 = get_argument(position, opcode, 1)
        put_result(v1 + v2, position, opcode, 2)
        instruction_length = 4
      when 2
        v1 = get_argument(position, opcode, 0)
        v2 = get_argument(position, opcode, 1)
        put_result(v1 * v2, position, opcode, 2)
        instruction_length = 4
      when 3
        put_result(@input, position, opcode, 0)
        instruction_length = 2
      when 4
        value = get_argument(position, opcode, 0)
        output_value(value)
        instruction_length = 2
      else
        raise "#{opcode} not an opcode!"
      end
      position += instruction_length
      opcode = @intcode[position]
    end
    # REVIEW do I need to test for diagnostic success?
    @intcode.join(',')
  end

  def operation(opcode)
    opcode%100
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

if __FILE__ == $0
  diagnostic_program = DATA.readline
  program = IntcodeProgram.new(diagnostic_program, input: 1)
  program.run
  print "\nOutput: #{program.output}\n\n"
end

__END__
3,225,1,225,6,6,1100,1,238,225,104,0,101,14,135,224,101,-69,224,224,4,224,1002,223,8,223,101,3,224,224,1,224,223,223,102,90,169,224,1001,224,-4590,224,4,224,1002,223,8,223,1001,224,1,224,1,224,223,223,1102,90,45,224,1001,224,-4050,224,4,224,102,8,223,223,101,5,224,224,1,224,223,223,1001,144,32,224,101,-72,224,224,4,224,102,8,223,223,101,3,224,224,1,223,224,223,1102,36,93,225,1101,88,52,225,1002,102,38,224,101,-3534,224,224,4,224,102,8,223,223,101,4,224,224,1,223,224,223,1102,15,57,225,1102,55,49,225,1102,11,33,225,1101,56,40,225,1,131,105,224,101,-103,224,224,4,224,102,8,223,223,1001,224,2,224,1,224,223,223,1102,51,39,225,1101,45,90,225,2,173,139,224,101,-495,224,224,4,224,1002,223,8,223,1001,224,5,224,1,223,224,223,1101,68,86,224,1001,224,-154,224,4,224,102,8,223,223,1001,224,1,224,1,224,223,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,108,226,677,224,1002,223,2,223,1006,224,329,1001,223,1,223,1007,226,226,224,1002,223,2,223,1006,224,344,101,1,223,223,1008,226,226,224,102,2,223,223,1006,224,359,1001,223,1,223,107,226,677,224,1002,223,2,223,1005,224,374,101,1,223,223,1107,677,226,224,102,2,223,223,1006,224,389,101,1,223,223,108,677,677,224,102,2,223,223,1006,224,404,1001,223,1,223,1108,677,226,224,102,2,223,223,1005,224,419,101,1,223,223,1007,677,226,224,1002,223,2,223,1006,224,434,101,1,223,223,1107,226,226,224,1002,223,2,223,1006,224,449,101,1,223,223,8,677,226,224,102,2,223,223,1006,224,464,1001,223,1,223,1107,226,677,224,102,2,223,223,1005,224,479,1001,223,1,223,1007,677,677,224,102,2,223,223,1005,224,494,1001,223,1,223,1108,677,677,224,102,2,223,223,1006,224,509,101,1,223,223,1008,677,677,224,102,2,223,223,1005,224,524,1001,223,1,223,107,226,226,224,1002,223,2,223,1005,224,539,101,1,223,223,7,226,226,224,102,2,223,223,1005,224,554,101,1,223,223,1108,226,677,224,1002,223,2,223,1006,224,569,1001,223,1,223,107,677,677,224,102,2,223,223,1005,224,584,101,1,223,223,7,677,226,224,1002,223,2,223,1005,224,599,101,1,223,223,108,226,226,224,1002,223,2,223,1005,224,614,101,1,223,223,1008,677,226,224,1002,223,2,223,1005,224,629,1001,223,1,223,7,226,677,224,102,2,223,223,1005,224,644,101,1,223,223,8,677,677,224,102,2,223,223,1005,224,659,1001,223,1,223,8,226,677,224,102,2,223,223,1006,224,674,1001,223,1,223,4,223,99,226