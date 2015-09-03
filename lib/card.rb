SUITS = [:H, :D, :C, :S]
RANKS = (2..10).to_a.map!{ |n| n.to_s(10) } + ["J", "Q", "K", "A"]
RANKING = {
  '2' => 2,
  '3' => 3,
  '4' => 4,
  '5' => 5,
  '6' => 6,
  '7' => 7,
  '8' => 8,
  '9' => 9,
  '10' => 10,
  'J' => 11,
  'Q' => 12,
  'K' => 13,
  'A' => 14,
  :H => 4,
  :D => 3,
  :C => 2,
  :S => 1
}

class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    fail "Invalid rank" unless RANKS.include?(rank)
    fail "Invalid suit" unless SUITS.include?(suit)
    @rank = rank
    @suit = suit
  end

  def reveal
    [rank, suit]
  end

  def beats?(other_card)
    if RANKING[self.rank] == RANKING[other_card.rank]
      RANKING[self.suit] <=> RANKING[other_card.suit]
    else
      RANKING[self.rank] <=> RANKING[other_card.rank]
    end
  end
end
