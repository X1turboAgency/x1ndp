@echo off

SET CMD=z80as.exe

SET WDIR=%~dp0
SET SRCDIR=%WDIR%\src

cd %SRCDIR%

SET SRC= ^
 value_define.asm main.asm uty.asm ndp.asm

rem SET SRC=boot_data.asm %SRC% prog_end.asm
SET DST=%WDIR%\x1ndp.com

echo アセンブル %SRC% → %DST%

%CMD% -o %DST% %SRC% -x

pause

