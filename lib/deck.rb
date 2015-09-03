require_relative 'card'

class Deck
  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        cards << Card.new(rank, suit)
      end
    end
    true
  end

  def count
    cards.count
  end

  def draw_card(n = 1)
    drawn = []
    n.times { drawn << cards.shift }
    drawn
  end

  def shuffle!
    @cards.shuffle!
  end

private
  attr_reader :cards

end
