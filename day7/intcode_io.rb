class IntcodeIO
  def initialize(values = [])
    @values = values
  end

  def values
    @values.dup
  end

  def read
    @values.shift
  end

  def write(output)
    @values << output
  end
end