#ifndef DEFINES_PACMAN
#define DEFINES_PACMAN

#define TRANS_COLOR 0
#define BLACK_COLOR 1
#define WHITE_COLOR 2
#define RED_COLOR 8
#define PINK_COLOR 4
#define BLUE_COLOR 7
#define ORANGE_COLOR 6

#define EYES_ACTIVE 2
#define SCARED_ACTIVE 1
#define NORMAL_ACTIVE 0

#define GHOST_DATA_SIZE 10
#define NUM_SPRITES 102-12
#define BIG_DOT 29
#define SMALL_DOT 30
;------------------
safeRAM2 = 0D052C6h  ; pixelshadow2
;------------------
MapData = safeRAM2
PacManY = MapData+(28*30)
PacManX = PacManX+1
PacManDir = PacManY+2
PacManSpriteCounter = PacManDir+1
keypress = PacManSpriteCounter+1
pacmanSprite = keypress+1
numdotseaten = pacmanSprite+3
fruitON = numdotseaten+1
ScatterModeON = fruitON+1
redGhostData = ScatterModeON+1
blueGhostData = redGhostData+10
pinkGhostData = blueGhostData+10
orangeGhostData = pinkGhostData+10
currFruitSprite = orangeGhostData+10
score = currFruitSprite+3
leftopen = score+3
downopen = leftopen+1
rightopen = downopen+1
upopen = rightopen+1
tmpStr = upopen+1
amtGhostsEaten = tmpStr+10
currFruitScore = amtGhostsEaten+3
needFlash = currFruitScore+3
FrightModeON = needFlash+1
tmpspeeds = FrightModeON+1
currGhostFlash = tmpspeeds+4
scatterActivatedTimes = currGhostFlash+4
frighttimerlvl = scatterActivatedTimes+1
currsec = frighttimerlvl+1
timer = currsec+1
fruitTimer = timer+1
frightTimer = fruitTimer+1
targetY = frightTimer+1
targetX = targetY+1
curTileY = targetX+2
curTileX = curTileY+1
redGhostSprite = curTileX+2
blueGhostSprite = redGhostSprite+3
pinkGhostSprite = blueGhostSprite+3
orangeGhostSprite = pinkGhostSprite+3
currGhostData = orangeGhostSprite+3
redGhostint = currGhostData+11
blueGhostint = redGhostint+1
pinkGhostint = blueGhostint+1
orangeGhostint = pinkGhostint+1
PTR = orangeGhostint+1
s200tmr = PTR+3
s400tmr = s200tmr+1
s800tmr = s400tmr+1
s1600tmr = s800tmr+1
s200loc = s1600tmr+1
s400loc = s200loc+3
s800loc = s400loc+3
s1600loc = s800loc+3
fruitsctmr = s1600loc+3
ScoreStrings = fruitsctmr+1
ScoreStrings2 = ScoreStrings+11
CursLoc = ScoreStrings2+11
CurrTable = CursLoc+3
HiScoreTbl = CurrTable+3
randData = HiScoreTbl+20
addedlife = randData+3
lives = addedlife+1
toggleCoins = lives+3
menuSel = toggleCoins+1
pressed2nd = menuSel+1
currLevel = pressed2nd+1
;------------------
PacManTempBuffer = 0D07396h
redghostbuf = PacManTempBuffer+(16*16)
blueghostbuf = redghostbuf+(16*16)
pinkghostbuf = blueghostbuf+(16*16)
orangeghostbuf = pinkghostbuf+(16*16)
;------------------
vBuf1 = vRAM
vBuf2 = vBuf1+(320*240)
;------------------
#endif