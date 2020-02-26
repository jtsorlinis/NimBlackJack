import card

let suits = @["Clubs", "Hearts", "Spades", "Diamonds"]
let ranks = @["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

type Deck* = ref object
    mCards*: seq[Card]

proc newDeck*(): Deck =
    new result
    for suit in suits:
        for rank in ranks:
            result.mCards.add(newCard(rank,suit))