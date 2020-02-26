import playertable
import cardpile
import times

var start = cpuTime()
var t = newTable(5, 8, 10, 40, true)
t.startRound()


echo cpuTime()-start
