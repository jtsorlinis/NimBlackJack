import cardpile
import times

var start = cpuTime()
var cp = newCardPile(5)
for i in 1..100000:
    cp.shuffle()
echo cp.print()

echo cpuTime()-start