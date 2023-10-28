/* sub test */
addi x1, x0, 123
addi x2, x0, 345
addi x3, x0, AB
addi x4, x0, 0
addi x5, x0, 0

sub x6, x2, x1 # x6 = 222

12300093
34500113
0AB00193
00000213
00000293
40110333



/* double hazard test */
addi x1, x0, 123
addi x2, x0, 345
addi x3, x0, AB
addi x4, x0, 0
addi x5, x0, 0
# double hazard
add x1, x2, x2 # x1 = 68a
add x1, x1, x2 # x1 = 9cf
sub x1, x1, x3 # x1 = 924

12300093
34500113
0AB00193
00000213
00000293
002100B3
002080B3
403080B3


/* double hazard test2 */
addi x1, x0, 123
addi x2, x0, 234
addi x3, x0, 345
addi x4, x0, 456
addi x5, x0, 789
addi x6, x0, 0
addi x7, x0, 0
addi x8, x0, 0

add x1, x2, x3 # x1 = 579
add x1, x1, x4 # x1 = 9CF
add x9, x1, x5 # x1 = 1158

12300093
23400113
34500193
45600213
78900293
00000313
00000393
00000413
003100B3
004080B3
005084B3


/* pipe reg test */
addi x1, x0, 123
addi x2, x0, 234
addi x3, x0, 345
addi x4, x0, 456
addi x5, x0, 789

add x6, x0, x1
add x7, x0, x2
add x8, x0, x3
add x9, x0, x4


12300093
23400113
34500193
45600213
78900293
00100333
002003B3
00300433
004004B3

//load and store
addi x1, x0, 123
addi x2, x0, 4
addi x3, x0, 789
slli x1, x1, 14
addi x4, x0, 222
slli x3, x3, 8
addi x5, x0, 88
addi x6, x0, 99
addi x10, x0, 23
add x1, x1, x5
addi x11, x0, 90
addi x12, x0, 43
add x1, x1, x3
sb  x1, 0(x2)
lw x1, 0(x2)
12300093
00400113
78900193
01409093
22200213
00819193
08800293
09900313
02300513
005080B3
09000593
04300613
003080B3
00110023
00012083

# 分支跳转测试，带冒险
addi x7, x0, 7 #x7 = 7
srli x3, x7, 1 # x3 = 3
addi x1, x0, 123 #x1 = 123
addi x2, x0,4 # x2 = 4
sw x1, 4(x2) # dmem[2] = 123
lw x5, 4(x2) # x5 = 123
add x6, x5, x7 # x6 = 12a
sub x1, x2, x3 # x1 = 1
or x7, x6, x7 # x7 = 12f
and x9, x7, x6 # x9 = 12a
add x7, x1, x7 # x7 = 130 
sub x9, x9, x1 # x9 = 129
bge x7, x9, _L1
add x1, x7, x1 # x1 = 25a
add x3, x2, x6
_L1:
	add x1, x9, x1 # x1 = 12a

00700393
0013D193
07B00093
00400113
00112223
00412283
00728333
403100B3
007363B3
0063F4B3
007083B3
401484B3
0093D663
001380B3
006101B3
001480B3


# jalr test 
addi x7, x0, 7 #x7 = 7
srli x3, x7, 1 # x3 = 3
addi x1, x0, 123 #x1 = 123
addi x2, x0,4 # x2 = 4
sw x1, 4(x2) # dmem[2] = 123
lw x5, 4(x2) # x5 = 123
add x6, x5, x7 # x6 = 12a
sub x1, x2, x3 # x1 = 1
or x7, x6, x7 # x7 = 12f
and x9, x7, x6 # x9 = 12a
add x7, x1, x7 # x7 = 130 
sub x9, x9, x1 # x9 = 129
jalr x2,x3,9
add x1, x7, x1 # x1 = 25a
add x3, x2, x6
_L1:
	add x1, x9, x1 # x1 = 12a

00700393
0013D193
07B00093
00400113
00112223
00412283
00728333
403100B3
007363B3
0063F4B3
007083B3
401484B3
00918167
001380B3
006101B3
001480B3


# double hazard test
addi x1, x0, 123
addi x2, x0, 345
addi x3, x0, AB
addi x4, x0, 0
addi x5, x0, 0
# double hazard
add x1, x2, x2 # x1 = 68a
add x1, x1, x2 # x1 = 9cf
sub x1, x1, x3 # x1 = 924

07B00093
15900113
0AB00193
00000213
00000293
002100B3
002080B3
403080B3
