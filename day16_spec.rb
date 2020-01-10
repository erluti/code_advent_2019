require './day16.rb'
require 'rspec'

describe SignalCleaner do
  it 'will receive 12345678 and return 48226158' do
    subject = SignalCleaner.new(input: '12345678')
    expect(subject.fft_phase).to eq '48226158'
  end
  it 'will receive 48226158 and return 34040438' do
    subject = SignalCleaner.new(input: '48226158')
    expect(subject.fft_phase).to eq '34040438'
  end
  it 'will receive 34040438 and return 03415518' do
    subject = SignalCleaner.new(input: '34040438')
    expect(subject.fft_phase).to eq '03415518'
  end
  it 'will receive 03415518 and return 01029498' do
    subject = SignalCleaner.new(input: '03415518')
    expect(subject.fft_phase).to eq '01029498'
  end

  it 'will receive 12345678 and after 4 phases return 01029498' do
    subject = SignalCleaner.new(input: '12345678')
    expect(subject.fft(4)).to eq '01029498'
  end

  describe 'large inputs with 100 phases' do
    it 'will receive 80871224585914546619083218645595 and after 100 phases return 24176176' do
      subject = SignalCleaner.new(input: '80871224585914546619083218645595')
      expect(subject.fft(100)).to eq '24176176'
    end
    it 'will receive 19617804207202209144916044189917 and after 100 phases return 73745418' do
      subject = SignalCleaner.new(input: '19617804207202209144916044189917')
      expect(subject.fft(100)).to eq '73745418'
    end
    it 'will receive 69317163492948606335995924319873 and after 100 phases return 52432133' do
      subject = SignalCleaner.new(input: '69317163492948606335995924319873')
      expect(subject.fft(100)).to eq '52432133'
    end
  end

  context 'part 2 -' do
    describe '100 phases with an offset' do
      it 'receives 03036732577212944063491565474664 and returns 84462026' do
        skip "This is computationally intense.  Need to optimize.  Googled hints show there's a pattern you can use if you work backwards."
        subject = SignalCleaner.new(input: '03036732577212944063491565474664', repeat: 10000)
        expect(subject.fft(100, offset: true)).to eq '52432133'
      end
      it 'receives 02935109699940807407585447034323 and returns 78725270'
      it 'receives 03081770884921959731165446850517 and returns 53553731'
    end
  end
end