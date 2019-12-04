require './day4.rb'
require 'rspec'

# RSpec.configure do |c|
#   c.filter_run_including :focus => true
# end

describe PasscodeVerifier do
  describe '#is_valid?' do
    it 'should be true for 111111' do
      expect(PasscodeVerifier.new(111111).is_valid?).to eq true
    end
    it 'should be false for 223450' do
      expect(PasscodeVerifier.new(223450).is_valid?).to eq false
    end
    it 'should be false for 123789' do
      expect(PasscodeVerifier.new(123789).is_valid?).to eq false
    end
  end
end
