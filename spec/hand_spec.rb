class BridgeHandCalculator

  def initialize(hand_input)
    @hand_input = hand_input
  end

  def score
    
    lines = @hand_input.split("\n")
    hand = parse_lines(lines)
    hand.score
  end

  def parse_lines(lines)
    Hand.new(lines.map do |line| 
      line[1..-1].chars.map(&method(:character_to_rank))
    end.flatten)
  end

  def character_to_rank(character)
    Rank.new(character)
  end

  private
  
end

class Hand
  
  def initialize(ranks)
    @ranks = ranks 
  end

  def score
    scores = @ranks.map { |rank| rank.score}
    scores.inject(:+)
  end
  
  
end

describe BridgeHandCalculator do

  describe '#score' do

    let(:subject) { described_class.new(hand_input).score }

    context 'when hand is worthless' do
      let(:hand_input) {"S????\nH???\nD???\nC???"}
      it { is_expected.to be 0 }
    end

    context 'when hand has an Ace' do
      let(:hand_input) {"SA???\nH???\nD???\nC???"}
      it { is_expected.to be 4 }
    end
  end
end 
