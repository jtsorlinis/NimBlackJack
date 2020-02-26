type Table* = ref object
    mBetSize*: int32
    mCasinoEarnings*: float32

proc newTable*(): Table =
    new result