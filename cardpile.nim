import card
import deck
import random

type CardPile* = ref object
    mCards*: seq[Card]
    mOriginalCards: seq[Card]

proc newCardPile*(numofdecks: int32): CardPile =
    randomize()
    new result
    for x in 0..<numofdecks:
        let temp = newDeck()
        result.mCards.add(temp.mCards)

    result.mOriginalCards = result.mCards

proc refresh*(self: CardPile) =
    self.mCards = self.mOriginalCards

proc print*(self: CardPile): string =
    result = ""
    for card in self.mCards:
        result.add(card.print())

proc shuffle*(self: CardPile) =
    for i in 0..<self.mCards.len:
        let j = rand(i)
        self.mCards[i].swap(self.mCards[j])
