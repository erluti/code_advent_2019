class PasscodeVerifier
  def initialize(passcode)
    @passcode = passcode
  end

  def is_valid?
    nil
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
