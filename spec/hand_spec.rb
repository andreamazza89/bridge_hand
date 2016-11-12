require 'active_support'
require 'active_support/core_ext'

class HandScorer < Struct.new(:hand_input)
  delegate :score, to: :hand

  def hand
    Hand.new(ranks)
  end

  def ranks
    ranks_for_lines.flatten
  end

  def ranks_for_lines
    lines.map(&method(:ranks_from_line))
  end

  def lines
    hand_input.split("\n")
  end

  def ranks_from_line(line)
    line_parser_for(line).ranks
  end

  def line_parser_for(line)
    LineParser.new(line)
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

class Hand

  def initialize(ranks)
    @ranks = ranks
  end

  def score
    rank_scores.inject(:+)
  end

  def rank_scores
    @ranks.map(&:score)
  end

end

describe HandScorer do

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
