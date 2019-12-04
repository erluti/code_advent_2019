class PasscodeVerifier
  def initialize(passcode)
    @passcode = passcode
  end

  def is_valid?
    return false if @passcode/100000 < 1
    code = @passcode.dup
    digits = []
    while code > 10
      digits.unshift(code%10)
      code /= 10
    end
    last = code
    double = false
    digits.each do |i|
      return false if i > last
      unless double
        double = i == last
      end
      last = i
    end
    double #everything else is valid, return wether or not the number contains a double
  end
end

if __FILE__ == $0
  raise 'Pass in min and max range as ARGs' unless ARGV.count == 2
  min = ARGV.shift.to_i
  max = ARGV.shift.to_i
  valid_passcode_count = (min..max).count do |passcode|
    PasscodeVerifier.new(passcode).is_valid?
  end
  print "\nCount of valid passcodes: #{valid_passcode_count}\n"
end
