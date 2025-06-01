@echo off

SET CMD=z80as.exe

SET WDIR=%~dp0
SET SRCDIR=%WDIR%\src

cd %SRCDIR%

SET SRC= ^
 value_define.asm main_x1_basic.asm uty.asm ndp.asm

SET DST=%WDIR%\x1ndp.bin

echo ÉAÉZÉìÉuÉã %SRC% Å® %DST%

%CMD% -o %DST% %SRC% -x

pause

