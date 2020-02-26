import player
import table
import cardpile
import times

var start = cpuTime()
var t = newTable()
var p = newPlayer(t)
echo p.print()

echo p.mPlayerNum
# var cp = newCardPile(5)
# for i in 1..100000:
#     cp.shuffle()
# echo cp.print()

echo cpuTime()-start