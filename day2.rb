class IntcodeProgram
  attr_reader :intcode

  def initialize(intcode)
    @intcode = intcode.split(',').map(&:to_i) # AKA memory
  end

  def run
    position = 0 # aka instruction pointer
    opcode = @intcode[0]
    # p "input: #{@intcode.join(',')}"
    while opcode != 99
      # p "process: #{@intcode.slice(position, 4)}"
      case opcode
      when 1
        output(values(position).sum, position)
      when 2
        output(values(position).reduce(&:*), position)
      else
        raise "#{opcode} not an opcode!"
      end
      position += 4
      opcode = @intcode[position]
      # p "result: #{@intcode.join(',')}"
    end
    @intcode.join(',')
  end

  def values(position)
    p1, p2 = [@intcode[position + 1], @intcode[position + 2]]
    [@intcode[p1], @intcode[p2]]
  end

  def output(value, position)
    p_out = @intcode[position + 3]
    @intcode[p_out] = value
  end

  def prime_data(position:, value:)
    @intcode[position] = value
  end
end

if __FILE__ == $0
  # part 1
  # program = IntcodeProgram.new(DATA.readline)
  # program.prime_data(position:1, value:12)
  # program.prime_data(position:2, value:2)
  # program.run
  # print "Value in position 0:\n#{program.intcode.first}\n"

  # part 2
  input = DATA.readline
  found = false
  noun, verb = nil, nil
  (0..99).each do |n|
    noun = n
    (0..99).each do |v|
      verb = v
      # p "prime with n #{n}, v #{v}"
      program = IntcodeProgram.new(input)
      program.prime_data(position: 1, value: noun)
      program.prime_data(position: 2, value: verb)
      program.run
      if program.intcode.first == 19690720
        found = true
        break
      end
    end
    break if found
  end
  print "Result:\n  Noun: #{noun}\n  Verb: #{verb}\n#{100*noun + verb}\n"
end

__END__
1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,2,9,19,23,2,13,23,27,1,6,27,31,2,6,31,35,2,13,35,39,1,39,10,43,2,43,13,47,1,9,47,51,1,51,13,55,1,55,13,59,2,59,13,63,1,63,6,67,2,6,67,71,1,5,71,75,2,6,75,79,1,5,79,83,2,83,6,87,1,5,87,91,1,6,91,95,2,95,6,99,1,5,99,103,1,6,103,107,1,107,2,111,1,111,5,0,99,2,14,0,0