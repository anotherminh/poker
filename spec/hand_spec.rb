require 'hand'
require 'rspec'

describe 'Hand' do
  let(:hand) { Hand.new }
  let(:ace_hearts) { double("card", suit: :H, rank: "A", reveal: ["A", :H]) }
  let(:ten_spades) { double("card", suit: :S, rank: "10", reveal: ["10", :S]) }
  let(:two_diamonds) { double("card", suit: :D, rank: "2") }
  let(:two_spades) { double("card", suit: :S, rank: "2") }

  describe 'Hand::initialize' do
    it 'initializes to an empty hand' do
      expect(hand.cards).to eq([])
    end

    it 'initializes to a hand with cards if cards are given' do
      hand_with_cards = Hand.new([:A, :B, :C, :D, :E])
      expect(hand_with_cards.cards).to eq([:A, :B, :C, :D, :E])
    end
  end

  describe '#receive_cards' do
    it 'stores the array of new cards' do
      hand.receive_cards(['card', 'card'])

      expect(hand.cards).to eq(['card', 'card'])
    end
  end

  describe '#show_hand' do
    it 'returns an array of the cards\' values' do
      hand.receive_cards([ace_hearts, ten_spades])

      expect(hand.show_hand).to eq([["A", :H], ["10", :S]])
    end
  end

  describe '#discard_cards' do
    before do
      some_cards = [:A, :B, :C, :D, :E]
      hand.receive_cards(some_cards)
    end

    it 'deletes the selected cards from the hand' do
      hand.discard_cards([1, 2, 3])
      expect(hand.cards).to eq([:A, :E])
    end
  end

  context 'counting cards' do
    before(:each) do
      hand.receive_cards([ace_hearts, ten_spades, two_diamonds, two_spades])
    end

    describe '#count_suits' do
      it 'returns a hash with suits as values and their counts' do
        expect(hand.count_suits).to eq({ :H => 1, :S => 2, :D =>1 })
      end
    end

    describe '#count_ranks' do
      it 'returns a hash with suits as values and their counts' do
        expect(hand.count_ranks).to eq({ "A" => 1, "10" => 1, "2" => 2 })
      end
    end
  end

  context 'game logic' do
    a_heart = Card.new("A", :H)
    a_spade = Card.new("A", :S)
    a_club = Card.new("A", :C)
    k = Card.new("K", :S)
    q = Card.new("Q", :C)
    j_club = Card.new("J", :C)
    j_diamond = Card.new("J", :D)
    j_heart = Card.new("J", :H)
    j_spade = Card.new("J", :S)
    ten = Card.new("10", :D)
    six = Card.new("6", :D)
    five_club = Card.new("5", :C)
    four_club = Card.new("4", :C)
    three_club = Card.new("3", :C)
    two_club = Card.new("2", :C)

    pairs = [a_heart, a_spade, j_diamond, j_heart, two_club]
    threes = [a_heart, j_diamond, j_heart, j_spade, two_club]
    full_house = [a_heart, a_spade, j_diamond, j_heart, j_spade]
    fours = [a_heart, j_diamond, j_heart, j_spade, j_club]
    straight = [a_heart, five_club, four_club, two_club, three_club]
    flush = [two_club, three_club, four_club, five_club, j_club]
    straight_flush = [two_club, three_club, four_club, five_club, a_club]
    high_card1 = [a_club, j_heart, k, q, three_club]
    high_card2 = [k, q, two_club, three_club, ten]
    win_by_straight = [a_heart, k, q, j_club, ten]
    lose_by_straight = [six, two_club, three_club, four_club, five_club]

    describe '#high_card' do
      sample_hand = Hand.new(pairs)
      it 'returns the highest card in hand' do
        expect(sample_hand.high_card).to eq(a_heart)
      end
    end

    describe '#same_rank' do
      hand_with_pairs = Hand.new(pairs)
      hand_with_threes = Hand.new(threes)
      hand_with_full_house = Hand.new(full_house)
      hand_with_fours = Hand.new(fours)

      it 'tells us if the highest hand is a pair(s)' do
        expect(hand_with_pairs.same_rank).to eq("Two Pairs")
      end

      it 'tells us if the highest hand is three of a kind' do
        expect(hand_with_threes.same_rank).to eq("Three Pairs")
      end

      it 'tells us if the highest hand is a full house' do
        expect(hand_with_full_house.same_rank).to eq("Full House")
      end

      it 'tells us if the highest hand is four of a kind' do
        expect(hand_with_fours.same_rank).to eq("Fours")
      end
    end

    describe '#flush?' do
      hand_w_flush = Hand.new(flush)
      hand_wo_flush = Hand.new(pairs)

      it 'returns true if there is a flush' do
        expect(hand_w_flush.flush?).to be true
      end

      it 'retursn false if there is no flush' do
        expect(hand_wo_flush.flush?).to be false
      end
    end

    describe '#straight?' do
      hand_w_straight = Hand.new(win_by_straight)
      hand_wo_straight = Hand.new(flush)

      it 'returns true if there is a straight' do
        expect(hand_w_straight.straight?).to be true
      end

      it 'returns false if there is no straight' do
        expect(hand_wo_straight.straight?).to be false
      end
    end

    describe '#straight_flush?' do
      hand_w_s_flush = Hand.new(straight_flush)
      it 'returns true if there is a straight flush' do
        expect(hand_w_s_flush.straight_flush?).to be true
      end
    end

    describe '#assign_score' do
      hand_w_straight = Hand.new(win_by_straight)
      hand_w_threes = Hand.new(threes)

      it 'returns the right score for a straight' do
        expect(hand_w_straight.assign_score).to eq(50)
      end

      it 'returns the right score for threes' do
        expect(hand_w_threes.assign_score).to eq(40)
      end
    end

    describe 'Hand::break_tie' do
      winner = Hand.new(high_card1)
      loser = Hand.new(high_card2)

      it 'returns the winner with the higher card' do
        expect(Hand.break_tie([winner, loser])).to eq([winner])
      end
    end

    describe 'Hand::winning_hand?' do
      winner = Hand.new(win_by_straight)
      loser = Hand.new(lose_by_straight)
      superloser = Hand.new(threes)

      it 'returns the winning hand when there is a tie (both straight flush)' do
        expect(Hand.winning_hand?([winner, loser, superloser])).to eq([winner])
      end
    end
  end
end
