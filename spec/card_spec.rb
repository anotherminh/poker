require 'card'
require 'rspec'

describe "Card" do
  let(:card) { Card.new("A", :H) }

  describe 'Card::initialize' do
    context 'creating a new card with invalid args' do
      it 'raises error if invalid rank is given' do
        expect{ Card.new(102, :H) }.to raise_error "Invalid rank"
      end

      it 'raises error if invalid suit is given' do
        expect{ Card.new("2", :G) }.to raise_error "Invalid suit"
      end
    end

    context 'creating a new card with valid arguments' do
      it "creates a new card with the given rank" do
        expect(card.rank).to eq("A")
      end

      it "creates a new card with the given suit" do
        expect(card.suit).to eq(:H)
      end
    end
  end

  describe '#reveal' do
    it 'returns an array of the cards\' rank and suit' do
      expect(card.reveal).to eq(["A", :H])
    end
  end

  describe '#beats?' do
    context 'when the rank is the same' do
      let(:big_card) { Card.new("A", :H) }
      let(:less_big_card) { Card.new("A", :D) }

      it 'returns 1 if the first card has higher suit' do
        big_card.beats?(less_big_card)
      end

      it 'returns -1 if the second card has higher suit' do
        less_big_card.beats?(big_card)
      end
    end

    context 'when the rank is different' do
      let(:big_card) { Card.new("10", :D) }
      let(:less_big_card) { Card.new("4", :H) }

      it 'returns 1 if the first card has higher rank' do
        big_card.beats?(less_big_card)
      end

      it 'returns -1 if the second card has higher rank' do
        less_big_card.beats?(big_card)
      end
    end
  end
end
