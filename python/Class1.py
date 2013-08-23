#Class1.py: wenlong
#Description: learn the oop in python using Card example
import sys

class Card:
    #class attributes like suit_list and rank_list are shared by all Card objects
    suit_list = ["Clubs", "Diamonds", "Hearts", "Spades"]
    rank_list = ["narf", "Ace", "2", "3", "4", "5", "6", "7",
                 "8", "9", "10", "Jack", "Queen", "King"]
            
    def __init__(self, suit=0, rank=2):
        self.suit = suit  #Spade, Heart, Diamond, Club
        self.rank = rank  #Ace,2,...,10,Jack, Queen, King

    def __str__(self):
        return self.rank_list[self.rank] + " of " + self.suit_list[self.suit]

    #overide the behavior of the built-in conditional operators
    def __cmp__(self, other):
        if self.suit > other.suit: return 1
        if self.suit < other.suit: return -1

        if self.rank > other.rank: return 1
        if self.rank < other.rank: return -1
        return 0

        
#each Deck object contains a list of cards as an attribute
class Deck:
    def __init__(self):
        self.cards = []
        for suit in range(4):
            for rank in range(1,14):
                self.cards.append(Card(suit, rank))

    def __str__(self):
        s = ""
        for i in range(self.cards):
            s = s + " "*i + str(self.cards[i]) + "\n"            
        return s



def main():
    card = Card(1,3)
    #import pdb; pdb.set_trace()
    print card

    deck = Deck()
    import pdb; pdb.set_trace()
    print deck

if __name__ == "__main__":
    main()
