require 'concurrent'

class IntcodeIO
  def initialize(values = [])
    @values = Concurrent::Array.new(values)
  end

  def values
    Array.new(@values) # read-only version of values
  end

  def read
    @values.shift
  end

  def write(output)
    @values << output
  end
end