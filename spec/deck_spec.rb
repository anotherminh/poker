require 'card'
require 'deck'
require 'rspec'

describe "Deck" do
  let(:card) { double("card") }
  subject(:test_deck) { Deck.new }

  describe "Deck::initialize" do
    context "creating a new deck" do
      it "creates a new deck" do
        expect(test_deck).to be_a(Deck)
      end

      it "has 52 cards" do
        expect(test_deck.count).to eq(52)
      end
    end
  end

  describe '#draw_card' do
    context "when no argument is given" do
      it "returns an array of 1 card" do
        drawn = test_deck.draw_card
        expect(drawn).to be_a(Array)
        expect(drawn[0]).to be_a(Card)
      end

      it "does not put that card back into the pile" do
        expect(test_deck.count).to be(52)

        test_deck.draw_card

        expect(test_deck.count).to be(51)
      end
    end

    context "when an argument is given" do
      it "returns that many cards" do
        expect(test_deck.count).to be(52)

        test_deck.draw_card(5)

        expect(test_deck.count).to be(47)
      end
    end
  end

  describe '#shuffle!' do
    it "shuffles the card" do
      expect(test_deck.instance_variable_get('@cards')).to receive(:shuffle!)
      test_deck.shuffle!
    end
  end
end
