require './day4.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe PasscodeVerifier do
  describe '#is_valid?' do
    it 'should be false for 111111' do
      expect(PasscodeVerifier.new(111111).is_valid?).to eq false
    end
    it 'should be false for 223450' do
      expect(PasscodeVerifier.new(223450).is_valid?).to eq false
    end
    it 'should be false for 123789' do
      expect(PasscodeVerifier.new(123789).is_valid?).to eq false
    end
    it 'should be true for 123788' do
      expect(PasscodeVerifier.new(123788).is_valid?).to eq true
    end
    it 'should be true for 112233' do
      expect(PasscodeVerifier.new(112233).is_valid?).to eq true
    end
    it 'should be false for 123444' do
      expect(PasscodeVerifier.new(123444).is_valid?).to eq false
    end
    it 'should be true for 111122' do
      expect(PasscodeVerifier.new(111122).is_valid?).to eq true
    end
  end
end
