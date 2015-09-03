require_relative 'card'
HAND_RANKS = {
  "One Pair" => 20,
  "Two Pairs" => 30,
  "Three Pairs" => 40,
  "Straight" => 50,
  "Flush" => 60,
  "Full House" => 70,
  "Fours" => 80,
  "Straight Flush" => 90
}

class Hand
  attr_accessor :cards
  attr_accessor :score
  def initialize(cards = [])
    @cards = cards
    @score = 0
  end

  def reset_score
    @score = 0
  end

  def receive_cards(new_cards)
    cards.concat(new_cards)
    true
  end

  def show_hand
    cards.map { |card| card.reveal }
  end

  def discard_cards(cards_ary)
    cards_ary.sort
    i = 0
    cards_ary.each do |n|
      cards.delete_at(n - i)
      i += 1
    end
  end

  def count_suits
    suit_counts = Hash.new(0)
    cards.each { |card| suit_counts[card.suit] += 1 }
    suit_counts
  end

  def count_ranks
    rank_counts = Hash.new(0)
    cards.each { |card| rank_counts[card.rank] += 1 }
    rank_counts
  end

#returns highest card in hand
  def high_card
    highest_card = cards.first
    cards[0..-2].each_with_index do |card1, idx1|
      idx2 = idx1 + 1
      while idx2 < 5
        card2 = cards[idx2]
        highest_card = card2 if card2.beats?(highest_card) == 1
        idx2 += 1
      end
    end
    highest_card
  end

  #check if there is fullhouse/fours/threes/pairs
  def same_rank
    ranks = count_ranks
    pairs = ranks.select { |_, count| count == 2 }
    threes = ranks.select { |_, count| count == 3 }
    fours = ranks.select { |_, count| count == 4 }

    if !fours.empty?
      return "Fours"
    elsif !pairs.empty? && !threes.empty?
      return "Full House"
    elsif !threes.empty?
      return "Three Pairs"
    elsif pairs.keys.count == 2
      return "Two Pairs"
    elsif pairs.keys.count == 1
      return "One Pair"
    else
      nil
    end
  end

  def flush? #same suit
    cards.all? { |card| card.suit == cards[0].suit }
  end

  def straight? #ranks are sequential
    ranks = cards.map { |card| Card::RANKING[card.rank] }.sort
    return true if ranks == [2, 3, 4, 5, 14] #takes care of A, 2, 3, 4, 5

    ranks[0..-2].each_with_index do |rank, idx|
      return false unless ranks[idx + 1] - rank == 1
    end
    true
  end

  def straight_flush?
    flush? && straight?
  end

  def assign_score
    if self.straight_flush?
      HAND_RANKS["Straight Flush"]
    elsif self.same_rank == "Fours"
      HAND_RANKS["Fours"]
    elsif self.same_rank == "Full House"
      HAND_RANKS["Full House"]
    elsif self.flush?
      HAND_RANKS["Flush"]
    elsif self.straight?
      HAND_RANKS["Straight"]
    elsif self.same_rank
      HAND_RANKS[self.same_rank]
    else
      0
    end
  end

#this just returns the winning_hand
  def self.winning_hand?(players_hands)
    #select the highest hand(s) first
    scores = Hash.new
    players_hands.each_with_index do |hand, idx|
      scores[idx] = hand.assign_score
    end

    highest_score = scores.values.sort.last

    highest_scored_players = scores.select { |_, score| score == highest_score }

    #check if there is a tie
    if highest_scored_players.count == 1
      return players_hands[highest_scored_players.first]
    end

    tied_players = highest_scored_players.map do |idx_and_score|
      players_hands[idx_and_score[0]]
    end

    Hand.break_tie(tied_players)
  end

  def self.break_tie(players_hands)
    players_and_scores = Hash.new

    players_hands.each_with_index do |hand, idx|
      players_and_scores[idx] = Card::RANKING[hand.high_card.rank]
    end

    highest_score = players_and_scores.values.sort.last

    #filter highest cards
    players_and_scores.select!{ |_, score| score == highest_score }

    players_and_scores.keys.map do |idx|
      players_hands[idx]
    end
  end
end
