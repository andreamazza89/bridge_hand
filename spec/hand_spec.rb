require 'active_support'
require 'active_support/core_ext'

class BridgeHandCalculator

  def initialize(hand_input)
    @hand_parser = HandParser.new(hand_input)
  end

  delegate :hand, to: :@hand_parser
  delegate :score, to: :hand

  private

  class HandParser < Struct.new(:hand_input)
    def hand
      parse_lines(input_lines)
    end

    def input_lines
      hand_input.split("\n")
    end

    def parse_lines(lines)
      Hand.new(
        lines.map(&method(:ranks_from_line)).flatten
      )
    end

    def ranks_from_line(line)
      LineParser.new(line).ranks
    end
  end

  class LineParser < Struct.new(:line)

    def ranks
      rank_chars.map(&method(:character_to_rank))
    end

    def rank_chars
      line[1..-1].chars
    end

    def character_to_rank(character)
      Rank.new(character)
    end

  end
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
