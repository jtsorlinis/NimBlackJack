import card
import deck
import times

var seed: uint32 = uint32(getTime().toUnix())

type CardPile* = ref object
    mCards*: seq[ptr Card]
    mOriginalCards: seq[Card]

proc xorShift(): uint32 =
    seed = seed xor (seed shl 13)
    seed = seed xor (seed shr 17)
    seed = seed xor (seed shl 5)
    return seed

proc refresh*(self: CardPile) =
    self.mCards.setLen(0)
    for card in self.mOriginalCards.mitems:
        self.mCards.add(addr card)

proc newCardPile*(numofdecks: int32): CardPile =
    new result
    for x in 0..<numofdecks:
        let temp = newDeck()
        result.mOriginalCards.add(temp.mCards)

    result.refresh()

proc print*(self: CardPile): string =
    result = ""
    for card in self.mCards:
        result.add(card[].print())

proc shuffle*(self: CardPile) =
    for i in 0..<self.mCards.len:
        let j = xorShift() mod uint32(i+1)
        self.mCards[i].swap(self.mCards[j])
