import strutils

let stratHard* = @[
@["0", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
@["2", "H", "H", "H", "H", "H", "H", "H", "H", "H", "H"],
@["3", "H", "H", "H", "H", "H", "H", "H", "H", "H", "H"],
@["4", "H", "H", "H", "H", "H", "H", "H", "H", "H", "H"],
@["5", "H", "H", "H", "H", "H", "H", "H", "H", "H", "H"],
@["6", "H", "H", "H", "H", "H", "H", "H", "H", "H", "H"],
@["7", "H", "H", "H", "H", "H", "H", "H", "H", "H", "H"],
@["8", "H", "H", "H", "H", "H", "H", "H", "H", "H", "H"],
@["9", "H", "D", "D", "D", "D", "H", "H", "H", "H", "H"],
@["10", "D", "D", "D", "D", "D", "D", "D", "D", "H", "H"],
@["11", "D", "D", "D", "D", "D", "D", "D", "D", "D", "H"],
@["12", "H", "H", "S", "S", "S", "H", "H", "H", "H", "H"],
@["13", "S", "S", "S", "S", "S", "H", "H", "H", "H", "H"],
@["14", "S", "S", "S", "S", "S", "H", "H", "H", "H", "H"],
@["15", "S", "S", "S", "S", "S", "H", "H", "H", "H", "H"],
@["16", "S", "S", "S", "S", "S", "H", "H", "H", "H", "H"],
@["17", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S"],
@["18", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S"],
@["19", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S"],
@["20", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S"],
@["21", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S"]]

let stratSoft* = @[
@["0", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
@["13", "H", "H", "H", "D", "D", "H", "H", "H", "H", "H"],
@["14", "H", "H", "H", "D", "D", "H", "H", "H", "H", "H"],
@["15", "H", "H", "D", "D", "D", "H", "H", "H", "H", "H"],
@["16", "H", "H", "D", "D", "D", "H", "H", "H", "H", "H"],
@["17", "H", "D", "D", "D", "D", "H", "H", "H", "H", "H"],
@["18", "S", "D", "D", "D", "D", "S", "S", "H", "H", "H"],
@["19", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S"],
@["20", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S"],
@["21", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S"]]

let stratSplit* = @[
@["0", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
@["2", "P", "P", "P", "P", "P", "P", "H", "H", "H", "H"],
@["3", "P", "P", "P", "P", "P", "P", "H", "H", "H", "H"],
@["4", "H", "H", "H", "P", "P", "H", "H", "H", "H", "H"],
@["6", "P", "P", "P", "P", "P", "H", "H", "H", "H", "H"],
@["7", "P", "P", "P", "P", "P", "P", "H", "H", "H", "H"],
@["8", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P"],
@["9", "P", "P", "P", "P", "P", "S", "P", "P", "S", "S"],
@["11", "P", "P", "P", "P", "P", "P", "P", "P", "P", "P"]]

proc getAction*(playerVal: int32, dealerVal: int32, strategy: seq[char]): char =
    let key = (playerVal + dealerVal) * (playerVal + dealerVal + 1) div 2 + dealerVal
    return strategy[key]

proc seqToMap*(arr: seq[seq[string]]): seq[char] =
    var temp = newSeq[char](1000)
    for row in 0..<arr.len():
        for col in 0..<arr[0].len():
            var playerVal = parseInt(arr[row][0])
            var dealerVal = parseInt(arr[0][col])
            var key = (playerVal + dealerVal) * (playerVal + dealerVal +
                    1) div 2 + dealerVal;
            temp[key] = arr[row][col][0];
    return temp
