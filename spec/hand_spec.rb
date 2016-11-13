require 'active_support'
require 'active_support/core_ext'

class HandScorer < Struct.new(:hand_input)
  def score
    line_scores.sum
  end

  def line_scores
    line_scorers.map(&:score)
  end

  def line_scorers
    lines.map { |line| LineScorer.new(line) }
  end

  def lines
    hand_input.split("\n")
  end

  def ranks_from_line(line)
    line_parser_for(line).ranks
  end

  def build_line_scorer(line)
    LineScorer.new(line)
  end
end

class LineScorer < Struct.new(:line)

  def score
    rank_scores.sum
  end

  def rank_scores
    ranks.map(&:score)
  end

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
