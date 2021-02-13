@echo off
color 0F
:loopbuild
set myvar="none"
set /p myvar="Enter [GFX] to build image data: "
if /i "%myvar%" == "GFX" GOTO imagebuild
GOTO skip
:imagebuild
echo.
cd /d data/gfx
call buildimages.bat
cd /d ../..
:skip
echo.
tools\spasm -E PacMan.asm PACMAN.8xp
echo.
goto loopbuild