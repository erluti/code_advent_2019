require 'byebug'
# num.abs%10 will get last digit of num, regardless of pos/neg

# create "phaser" that will take an input and return the output, contains the base pattern internally
class SignalCleaner
  attr_reader :current_phase, :current
  def initialize(input:)
    @input = input
    @current = number_as_array(input)
    @current_phase = 0
    @base_pattern = [0, 1, 0, -1]
  end

  def fft_phase
    result = []
    @current.length.times do |i|
      pattern = pattern_for_position(i+1)
      result << @current.collect{|v| v * pattern.rotate!.first}.sum.abs % 10
    end
    @current = result
    @current_phase += 1
    @current.join('')
  end

  def fft(phase_count)
    phase_count.times do
      fft_phase
    end
    @current.first(8).join('')
  end

private
  # 1-indexed
  def pattern_for_position(position)
    pattern = []
    @base_pattern.each do |value|
      pattern += [value] * position
    end
    pattern
  end

  def number_as_array(number)
    number.split('').map(&:to_i)
  end
end

if __FILE__ == $0
  input = DATA.readline
  cleaner = SignalCleaner.new(input: input)
  first8 = cleaner.fft(100)
  print "First 8 after 100 phases: #{first8}\n\n"
end
__END__
59773775883217736423759431065821647306353420453506194937477909478357279250527959717515453593953697526882172199401149893789300695782513381578519607082690498042922082853622468730359031443128253024761190886248093463388723595869794965934425375464188783095560858698959059899665146868388800302242666479679987279787144346712262803568907779621609528347260035619258134850854741360515089631116920328622677237196915348865412336221562817250057035898092525020837239100456855355496177944747496249192354750965666437121797601987523473707071258599440525572142300549600825381432815592726865051526418740875442413571535945830954724825314675166862626566783107780527347044