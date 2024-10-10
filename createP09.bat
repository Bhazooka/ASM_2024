REM Mr. A. Maganlal
REM Computer Science 3B 2016 - 2023
REM This batch file is setup to be more robust than previous versions
@echo off
setlocal enabledelayedexpansion
set PROJNAME=%~1
set ERRMSG=

if "%PROJNAME%"=="" (
    echo "Usage: create [asmFileNameWithoutExtension]"
    goto END
)

:CLEAN
echo "~~~ Cleaning project ~~~"
DEL /S %PROJNAME%.exe %PROJNAME%.ilk %PROJNAME%.pdb %PROJNAME%.lst %PROJNAME%.obj
IF /I "%ERRORLEVEL%" NEQ "0" (
    set ERRMSG="Cleaning"
    GOTO ERROR
)

:ASSEMBLE
echo "~~~ Assembling project ~~~"
.\assembler\ml.exe /c /coff /Fl /Zi src\%PROJNAME%.asm
IF /I "%ERRORLEVEL%" NEQ "0" (
    set ERRMSG="Assembling"
    GOTO ERROR
)

:LINK
echo "~~~ Linking DLL ~~~"
.\assembler\link.exe /dll /subsystem:console /def:src/P09.def /out:bin\P09.dll P09.obj 
IF /I "%ERRORLEVEL%" NEQ "0" (
    set ERRMSG="Linking"
    GOTO ERROR
)

@REM :RUN
@REM echo "~~~ Running project ~~~"
@REM bin\%PROJNAME%.exe
@REM IF /I "%ERRORLEVEL%" NEQ "0" (
@REM     set ERRMSG="Running"
@REM     GOTO ERROR
@REM )
GOTO END

:ERROR
echo "!!! An error has occured !!!"
echo %ERRMSG%
pause

:END
echo "~~~ End ~~~"