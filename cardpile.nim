import card
import deck
import xorshift
import times

type CardPile* = ref object
    mCards*: seq[Card]
    mOriginalCards: seq[Card]
    rnd: Xorshift64StarState

proc newCardPile*(numofdecks: int32): CardPile =
    new result
    result.rnd.x = uint64(getTime().toUnix())
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
        let j = uint32(self.rnd.next()) mod uint32(i+1)
        self.mCards[i].swap(self.mCards[j])
