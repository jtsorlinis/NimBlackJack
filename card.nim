import strutils

type
    Card* = object
        mRank: string
        mSuit: string
        mFaceDown: bool
        mValue*: int32
        mCount*: int32
        mIsAce: bool

proc evaluate(self: ref Card): int32 =
    if self.mRank == "J" or self.mRank == "Q" or self.mRank == "K":
        result = 10
    elif self.mRank == "A":
        result = 11
    else:
        result = int32(parseInt(self.mRank))

proc count(self: ref Card): int32 =
    if self.mRank == "10" or self.mRank == "J" or self.mRank == "Q" or self.mRank == "K" or self.mRank == "A":
        result = -1
    elif self.mRank == "7" or self.mRank == "8" or self.mRank == "9":
        result = 0
    else:
        result = 1

proc newCard*(rank: string, suit: string): ref Card =
    let c = new Card
    c.mRank = rank
    c.mSuit = suit
    c.mFaceDown = false
    c.mValue = c.evaluate()
    c.mCount = c.count()
    c.mIsAce = false
    result = c

proc print*(self: ref Card): string =
    if self.mFaceDown:
        result = "X"
    else:
        result = self.mRank
    
