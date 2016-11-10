class Rank
  def initialize(rank)
    @rank = rank
  end

  def score
   return 4 if @rank == "A"
   return 3 if @rank == "K"
   return 2 if @rank == "Q"
   return 1 if @rank == "J"
   0
  end
end

describe Rank do

  describe '#score' do

    let(:subject) { described_class.new(rank).score }

    context 'when rank is Ace' do
      let(:rank) {"A"}
      it { is_expected.to be 4 }
    end

    context 'when rank is King' do
      let(:rank) {"K"}
      it { is_expected.to be 3 }
    end

    context 'when rank is Queen' do
      let(:rank) {"Q"}
      it { is_expected.to be 2 }
    end

    context 'when rank is Jack' do
      let(:rank) {"J"}
      it { is_expected.to be 1 }
    end

    context 'when rank is ?' do
      let(:rank) {"?"}
      it { is_expected.to be 0 }
    end
  end
end 
