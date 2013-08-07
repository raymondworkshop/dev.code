#! /usr/bin/ipython
import os; os.chdir("/home/zhaowenlong/workspace/proj/dev.mycode/")
#Inheritance.py -- wenlong
#Function: -- an example to learn the inheritance in python
#          -- Reference ch15 and ch16 in "How to Think Like a Computer Scientist"
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
        for i in range(len(self.cards)):
            s = s + " "*i + str(self.cards[i]) + "\n"            
        return s

    #shuffle the deck
    def Shuffle(self):
        import random
        num_cards = len(self.cards)
        for i in range(num_cards):
            #randrange(a,b) chooses a<=x<b
            j = random.randrange(i, num_cards)
            self.cards[i], self.cards[j] = self.cards[j], self.cards[i]

    def RemoveCard(self, card):
        if card in self.cards:
            #card is an object, 
            #python uses card's __cmp__ method to determine equality with items in this list
            self.cards.remove(card)
            return True
        else:
            return False

    def PopCard(self):
        return self.cards.pop()

    def IsEmpty(self):
        return (len(self.cards) == 0)

    # deal cards
    def Deal(self, hands, num_cards=999):
        import random
        #a list of hands
        num_hands = len(hands);
        for i in range(num_cards):
            if self.IsEmpty(): break
            card = self.PopCard()
            hand = hands[i % num_hands] #whose turn is next
            hand.AddCard(card)

#a hand of cards       
class Hand(Deck):
    def __init__(self, name=""):
        self.cards = []
        self.name = name

    def __str__(self):
        s = "Hand " + self.name
        if self.IsEmpty():
            return s + " is empty\n"
        else:
            return s + " contains\n" + Deck.__str__(self) #send a Hand to a Deck method

    def AddCard(self, card):
        self.cards.append(card)


class CardGame:
    def __init__(self):
        self.deck = Deck()
        self.deck.Shuffle()


#Old Maid game requires some abilities beyong the general abilities of a Hand        
class OldMaidHand(Hand):
    # __init__ method for OldMaidHand inherit from Hand
    def RemoveMatches(self):
        count = 0
        original_cards = self.cards[:]
        for card in original_cards:
            #turn a Club(suit 0) into a Spade(suit 3)
            #a Diamond(suit 1) into a Heart(suit 2)
            match = Card(3 - card.suit, card.rank)
            if match in self.cards:
                self.cards.remove(card)
                self.cards.remove(match)
                print "Hand %s: %s matches %s" % (self.name, card, match)
                count = count + 1
        return count

class OldMaidGame(CardGame):
    def RemoveAllMatches(self):
        count = 0
        for hand in self.hands:
            count = count + hand.RemoveMatches()
        return count
        
    def PlayOneTurn(self, i):
        #i indicates whose turn it is
        if self.hands[i].IsEmpty():
            return 0
        neighbor = self.FindNeighbor(i)
        picked_card = self.hands[neighbor].PopCard()
        self.hands[i].AddCard(picked_card)
        print "Hand", self.hands[i].name, "picked", picked_card
        count = self.hands[i].RemoveMatches()
        self.hands[i].Shuffle()
        return count

    def FindNeighbor(self, i):
        num_hands = len(self.hands)
        for next in range(1, num_hands):
            neighbor = (i + next) % num_hands
                if not self.hands[neighbor].IsEmpty():
                    return neighbor

    def PrintHands(self):
        for hand in self.hands:
            print hand
        
    def Play(self, names):
        #remove Queen of Clubs for this game
        self.deck.RemoveCard(Card(0, 12))

        #make a hand for each player
        self.hands = []
        for name in names:
            self.hands.append(OldMaidHand(name))

        #deal the cards
        self.deck.Deal(self.hands)
        print "---Cards have been dealt"
        self.PrintHands()

        #remove initial matches
        matches = self.RemoveAllMatches()
        print "---Matches discarded, play begins"
        self.PrintHands()

        #play until all 50 cards are matched
        turn = 0  #which player's turn
        num_hands = len(self.hands)
        while matches < 25:  #50 cards have been removed, and only one card is left and the game is over
            matches = matches + self.PlayOneTurn(turn)
            turn = (turn + 1) % num_hands

        print "---Game is Over"
        self.PrintHands()

def main():
    card = Card(1,3)
    print card

    deck = Deck()
    #import pdb; pdb.set_trace()
    deck.Shuffle()
    hand = OldMaidHand("frank")
    import pdb; pdb.set_trace()
    deck.Deal([hand], 13) #each hand has 13 cards
    hand.RemoveMatches()
    import pdb; pdb.set_trace()
    print hand

    game = OldMaidGame()
    game.Play(["Allen", "Jeff", "Chris"])
    

if __name__ == "__main__":
    main()
