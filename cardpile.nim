import card
import deck
import times

var seed: uint32 = uint32(getTime().toUnix())

type CardPile* = ref object
    mCards*: seq[Card]
    mOriginalCards: seq[Card]

proc xorShift(): uint32 =
    seed = seed xor (seed shl 13)
    seed = seed xor (seed shr 17)
    seed = seed xor (seed shl 5)
    return seed

proc newCardPile*(numofdecks: int32): CardPile =
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
        let j = xorShift() mod uint32(i+1)
        self.mCards[i].swap(self.mCards[j])
