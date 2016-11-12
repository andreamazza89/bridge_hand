require 'active_support'
require 'active_support/core_ext'

class BridgeHandCalculator

  def initialize(hand_input)
    @hand_input = hand_input
  end

  delegate :score, to: :hand

  def hand
    parse_lines(input_lines)
  end

  def input_lines
    @hand_input.split("\n")
  end

  def parse_lines(lines)
    Hand.new(lines.map do |line|
      LineParser.new(line).ranks
    end.flatten)
  end

  private

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
