import card
import deck
import random

type
    CardPile* = ref object
        mCards: seq[Card]
        mOriginalCards: seq[Card]

proc newCardPile*(numofdecks: int32): CardPile =
    randomize()
    new result
    for x in 0..numofdecks:
        let temp = newDeck()
        add(result.mCards,temp.mCards)

proc print*(self: CardPile): string =
    result = ""
    for card in self.mCards:
        add(result,card.print())

proc shuffle*(self: CardPile) = 
    for i in 0..<self.mCards.len:
        let j = rand(i)
        swap(self.mCards[i], self.mCards[j])