import card
import deck
import times

var state: uint64 = uint32(getTime().toUnix())

type CardPile* = ref object
    mCards*: seq[ptr Card]
    mOriginalCards: seq[Card]

# From https://www.pcg-random.org/download.html#minimal-c-implementation
proc pcg32(): uint32 =
    let oldstate = state
    state = oldstate * 6364136223846793005'u64 + 1
    let xorshifted = ((oldstate shr 18) xor oldstate) shr 27
    let rot = oldstate shr 59
    return uint32((xorshifted shr rot) or (xorshifted shl (uint32(-(int32(rot))) and 31)))

# From https://github.com/lemire/FastShuffleExperiments
proc pcg32Range(s: uint32): uint32 =
    var x = pcg32()
    var m = uint64(x) * uint64(s)
    var l = uint64(m)
    if l < s:
        let t = uint32(-(int32(s))) mod s
        while l < t:
            x = pcg32()
            m = uint64(x) * uint64(s)
            l = uint64(m)
    return uint32(m shr 32)
            

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
        let j = pcg32Range(uint32(i+1))
        self.mCards[i].swap(self.mCards[j])
