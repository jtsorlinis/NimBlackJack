import card
import deck
import random

type
    CardPile* = object
        mCards: seq[ref Card]
        mOriginalCards: seq[ref Card]

proc newCardPile*(numofdecks: int32): ref CardPile =
    randomize()
    let cp = new CardPile
    for x in 0..numofdecks:
        let temp = newDeck()
        add(cp.mCards,temp.mCards)
    result = cp

proc print*(self: ref CardPile): string =
    result = ""
    for card in self.mCards:
        add(result,card.print())

proc shuffle*(self: ref CardPile) = 
    for i in 0..<self.mCards.len:
        let j = rand(i)
        swap(self.mCards[i], self.mCards[j])