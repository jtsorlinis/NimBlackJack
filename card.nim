import strutils

type Card* = object
    mRank*: string
    mSuit: string
    mFaceDown*: bool
    mValue*: int32
    mCount*: int32
    mIsAce*: bool

proc evaluate(self: Card): int32 =
    if self.mRank == "J" or self.mRank == "Q" or self.mRank == "K":
        result = 10
    elif self.mRank == "A":
        result = 11
    else:
        result = int32(parseInt(self.mRank))

proc count(self: Card): int32 =
    if self.mRank == "10" or self.mRank == "J" or self.mRank == "Q" or
            self.mRank == "K" or self.mRank == "A":
        result = -1
    elif self.mRank == "7" or self.mRank == "8" or self.mRank == "9":
        result = 0
    else:
        result = 1

proc newCard*(rank: string, suit: string): Card =
    result.mRank = rank
    result.mSuit = suit
    result.mFaceDown = false
    result.mValue = result.evaluate()
    result.mCount = result.count()
    result.mIsAce = rank == "A"

proc print*(self: Card): string =
    if self.mFaceDown:
        result = "X"
    else:
        result = self.mRank

