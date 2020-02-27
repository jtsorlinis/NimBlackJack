type Xorshift64StarState* = object
  x*: uint64 # The state must be seeded with a nonzero value.

proc next*(s: var Xorshift64StarState): uint64 =
  s.x = s.x xor (s.x shr 12) # a
  s.x = s.x xor (s.x shl 25) # b
  s.x = s.x xor (s.x shr 27) # c
  return s.x * 2685821657736338717u64