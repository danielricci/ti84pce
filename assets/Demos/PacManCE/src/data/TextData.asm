;------------------------------------ 
; -TEXT DATA-
;-----------------------------------

InsertCoinString:
	.db "INSERT COIN",0
NewHighString:
	.db "NEW HIGH SCORE?",0
ScoreString:
	.db "SCORE",0
LevelString:
	.db "LEVEL",0
BlinkyTextString:
	.db "SHADOW        @BLINKY@",0
PinkyTextString:
	.db "SPEEDY        @PINKY@",0
InkyTextString:
	.db "BASHFUL       @INKY@",0
ClydeTextString:
	.db "POKEY         @CLYDE@",0
QuitGameString:
	.db "QUIT",0
NoString:
	.db "NO",0
YesString:
	.db "YES",0
TenPTSString:
	.db "10 PTS",0
FiftyPTSString:
	.db "50 PTS",0
Times1String:
	.db ">1 200 PTS",0
Times2String:
	.db ">2 400 PTS",0
Times3String:
	.db ">3 800 PTS",0
Times4String:
	.db ">4 1600 PTS",0
BonusString:
	.db "BONUS PACMAN AT 10000 PTS",0
HackedString:
	.db "HACKED VERSION",0
CursChar:
	.db ';'
emptyScore:
	.db ">>>>>>>>>>",0	; These are Actually "x"'s
	.dl 0
	.db 0
emptyScore_end:
mateoScore:
	.db "MATEO     ",0
	.dl 10000
	.db 0
mateoScore_end:

pacManAppVar:
	.db appvarobj,"PacMan",0
 
;------------------------------------ 
; -DATA-
;------------------------------------
 
updist:
	.dl 0
leftdist:
	.dl 0
rightdist:
	.dl 0
downdist:
	.dl 0
PacManStartY:
	.db 173
PacManStartX:
	.db 106
PacManStartDir:
	.db 0
level1ghostspeed:
	.db 3,4,6,20
LevelFrightTimmings:
	.db 6,5,4,3,2,5,2,3,5,2,2,2,3,2,2,1,2
FruitLvlTypes:
	.db 0,1,2,2,3,3,4,4,5,5,6,6,7
FruitLvlScores:
	.db 1,3,5,5,7,7,10,10,20,20,30,30,50
redGhostDataS: 
	.db 85,105,0,0,0,0,0,3,0,0
blueGhostDataS: 
	.db 104,105-16,0,0,0,0,0,3,$FF,0
pinkGhostDataS: 
	.db 104,105,0,0,0,0,0,3,$FF,0
orangeGhostDataS: 
	.db 104,105+16,0,0,0,0,0,3,$FF,0