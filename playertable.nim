import card
import cardpile

var playerNumCount = 0
let maxSplits = 10

type
    Table* = ref object
        mDealer: Dealer
        mMincards: int32
        mNumOfDecks: int32
        mStratHard: bool
        mStratSoft: bool
        mStratSplit: bool
        mVerbose: bool
        mBetSize*: int32
        mCardPile*: CardPile
        mPlayers: seq[Player]
        mCurrentPlayer: int32
        mRunningcount: int32
        mTruecount: int32
        mCasinoEarnings*: float32

    Player* = ref object of RootObj
        mTable: Table
        mHand: seq[Card]
        mSplitFrom: Player
        mAces: int32
        mSplitcount: int32
        mBetMult: float32
        mEarnings: float32
        mHasNatural: bool
        mInitialBet: int32
        mIsDone: bool
        mIsSoft: bool
        mPlayerNum*: string
        mValue*: int32

    Dealer* = ref object of Player

# Dealer Methods
proc newDealer(): Dealer =
    new result
    result.mPlayerNum = "D"
    result.mValue = 0

proc resetHand(self: Dealer) =
    #TODO: see if this or setlen(0) is faster
    self.mHand = @[]
    self.mValue = 0

proc upCard(self: Dealer): int32 =
    return self.mHand[0].mValue

# Player Methods
proc newPlayer*(table: Table = nil, split: Player = nil): Player =
    new result
    result.mTable = table
    if table == nil:
        return
    result.mInitialBet = result.mTable.mBetSize
    if split != nil:
        result.mHand.add(split.mHand[1])
        result.mSplitcount += 1
        result.mPlayerNum = split.mPlayerNum & "S"
        result.mSplitFrom = split
    else:
        playerNumCount += 1
        result.mPlayerNum = $playerNumCount

proc doubleBet(self: Player) =
    self.mBetMult = 2

proc resetHand*(self: Player) =
    #TODO: see if this or setlen(0) is faster
    self.mHand = @[]
    self.mValue = 0
    self.mAces = 0
    self.mIsSoft = false
    self.mSplitcount = 0
    self.mIsDone = false
    self.mBetMult = 1
    self.mHasNatural = false
    self.mInitialBet = self.mTable.mBetSize

proc canSplit(self: Player): int32 =
    if self.mHand.len() == 2 and self.mHand[0].mRank == self.mHand[1].mRank and
            self.mSplitcount < maxSplits:
        return self.mHand[0].mValue
    return 0

proc win(self: Player, mult: float32 = 1) =
    if self.mSplitFrom != nil:
        self.mSplitFrom.win(mult)
    else:
        self.mEarnings += float32(self.mInitialBet) * self.mBetMult * mult
        self.mTable.mCasinoEarnings -= float32(self.mInitialBet) *
                self.mBetMult * mult

proc lose(self: Player) =
    if self.mSplitFrom != nil:
        self.mSplitFrom.lose()
    else:
        self.mEarnings -= float32(self.mInitialBet) * self.mBetMult
        self.mTable.mCasinoEarnings += float32(self.mInitialBet) * self.mBetMult

proc print*(self: Player): string =
    var output = "Player " & self.mPlayerNum & ": "
    for card in self.mHand:
        output.add(card.print() & " ")
    for i in self.mHand.len()..<5:
        output.add("  ")
    output.add("\tScore: " & $self.mValue)
    if self.mValue > 21:
        output.add(" (Bust) ")
    else:
        output.add("        ")
    if self.mPlayerNum != "D":
        let val = float32(self.mInitialBet) * self.mBetMult
        output.add("\tBet: " & $val)
    return output

proc evaluate*(self: Player) =
    self.mAces = 0
    self.mValue = 0
    for card in self.mHand:
        self.mValue += card.mValue
        # check for ace
        if card.mIsAce:
            self.mAces += 1
            self.mIsSoft = true
    while self.mValue > 21 and self.mAces > 0:
        self.mValue -= 10
        self.mAces -= 1
    self.mIsSoft = self.mAces != 0


# Table methods
proc newTable*(numPlayers: int32, numDecks: int32, betSize: int32,
        minCards: int32, verbose: bool): Table =
    new result
    result.mCardPile = newCardPile(numDecks)
    result.mVerbose = verbose
    result.mBetSize = betSize
    result.mNumOfDecks = numDecks
    result.mMincards = minCards
    result.mDealer = newDealer()

    for i in 0..<numPlayers:
        result.mPlayers.add(newPlayer(result))

proc deal(self: Table) =
    var card = self.mCardPile.mCards.pop()
    self.mPlayers[self.mCurrentPlayer].mHand.add(card)
    self.mRunningcount += card.mCount

proc dealRound(self: Table) =
    for player in self.mPlayers:
        self.deal()
        self.mCurrentPlayer += 1
    self.mCurrentPlayer = 0

proc evaluateAll(self: Table) =
    for player in self.mPlayers:
        player.evaluate()

proc selectBet(self: Table, player: Player) =
    if self.mTruecount >= 2:
        player.mInitialBet = self.mBetSize * (self.mTruecount - 1)

proc preDeal(self: Table) =
    for player in self.mPlayers:
        self.selectBet(player)

proc dealDealer(self: Table, facedown: bool = false) =
    var card = self.mCardPile.mCards.pop()
    card.mFaceDown = facedown
    self.mDealer.mHand.add(card)
    if not facedown:
        self.mRunningcount += card.mCount

proc getNewCards(self: Table) =
    if self.mCardPile.mCards.len() >= self.mMincards:
        return
    self.mCardPile.refresh()
    self.mCardPile.shuffle()
    self.mTruecount = 0
    self.mRunningcount = 0
    if self.mVerbose:
        echo "Got " & $self.mNumOfDecks & " new decks as number of cards left is below " & $self.mMincards

proc clear(self: Table) =
    for i in countdown(self.mPlayers.len()-1, 0):
        self.mPlayers[i].resetHand()
        if self.mPlayers[i].mSplitFrom != nil:
            self.mPlayers.delete(i)
    self.mDealer.resetHand()
    self.mCurrentPlayer = 0
            

proc updateCount(self: Table) =
    if self.mCardPile.mCards.len() > 51:
        self.mTruecount = self.mRunningcount div int32(self.mCardPile.mCards.len() div 52)

proc hit(self: Table) =
    #TODO
    return

proc stand(self: Table) =
    #TODO
    return

proc split(self: Table) =
    #TODO
    return

proc splitAces(self: Table) =
    #TODO
    return

proc doubleBet(self: Table) =
    #TODO
    return

proc autoPlay(self: Table) =
    #TODO
    return

proc action(self: Table, act: string) =
    #TODO
    return

proc dealerPlay(self: Table) =
    #TODO
    return

proc nextPlayer(self: Table) =
    #TODO
    return

proc checkPlayerNatural(self: Table) =
    #TODO
    return

proc checkDealerNatural(self: Table): bool =
    #TODO
    return

proc checkEarnings(self: Table) =
    #TODO
    return

proc finishRound(self: Table) =
    #TODO
    return

proc print*(self: Table) =
    for player in self.mPlayers:
        echo player.print()
    echo self.mDealer.print()
    echo ""

proc startRound*(self: Table) =
    self.clear()
    self.updateCount()
    if self.mVerbose:
        echo $self.mCardPile.mCards.len() & " cards left"
        echo "Running count is: " & $self.mRunningcount & "\tTrue count is: " &
                $self.mTruecount
    self.getNewCards()
    self.preDeal()
    self.dealRound()
    self.dealDealer()
    self.dealRound()
    self.dealDealer(true)
    self.evaluateAll()
    self.mCurrentPlayer = 0
    if self.checkDealerNatural():
        self.finishRound()
    else:
        self.checkPlayerNatural()
        if self.mVerbose:
            self.print()
        self.autoPlay()
