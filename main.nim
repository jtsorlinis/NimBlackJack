import os, strutils
import playertable
import cardpile
import times
import strategies

let numOfPlayers: int32 = 5
let numOfDecks: int32 = 8
let betSize: int32 = 10
let minCards: int32 = 40

var rounds = 1000000
let verbose = false

if os.commandLineParams().len() == 1:
    rounds = int32(parseInt(os.commandLineParams()[0]))

var t = newTable(numOfPlayers, numOfDecks, betSize, minCards, verbose)
t.mCardPile.shuffle()

var start = cpuTime()

for x in 1..rounds:
    if verbose:
        echo "Round " & $x
    if not verbose and rounds > 1000 and x mod (rounds div 100) == 0:
        let prog = x*100/rounds
        stdout.write "\tProgress: " & $prog & "%\r"
        stdout.flushFile()
    t.startRound()
    t.checkEarnings()

t.clear()

for player in t.mPlayers:
    let winperc = 50 + player.mEarnings / float32(rounds * betSize) * 50
    echo "Player " & player.mPlayerNum & " earnings: " & $player.mEarnings &
            "\t\tWin Percentage: " & $winperc & "%"

echo "Casino earnings: " & $t.mCasinoEarnings
echo "Played " & $rounds & " rounds in " & $(cpuTime()-start) & " seconds"
