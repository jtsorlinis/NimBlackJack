import card
import random

let suits = @["Clubs", "Hearts", "Spades", "Diamonds"]
let ranks = @["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

type
    Deck* = object
        mCards: seq[ref Card]

proc newDeck*(): ref Deck =
    let d = new Deck
    for suit in suits:
        for rank in ranks:
            d.mCards.add(newCard(rank,suit))
    result = d


proc print*(self: ref Deck): string =
    result = ""
    for card in self.mCards:
        add(result,card.print())

proc shuffle*(self: ref Deck) = 
    for i in 0..<self.mCards.len:
        let j = rand(i)
        swap(self.mCards[i], self.mCards[j])