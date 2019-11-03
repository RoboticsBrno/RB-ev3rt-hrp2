:: Script for building EV3RT application
:: Author: Jaroslav Páral (jarekparal) 
:: Version: 1.2 (2019-11-03)

setlocal enabledelayedexpansion
@set "cygwin=C:\tools\cygwin"

@IF NOT EXIST %cygwin% (
    set "cygwin=C:\cygwin64"

    echo %cygwin%
    @IF NOT EXIST !cygwin! (
        echo The Cygwin tools is not available in expected paths:
        echo - C:\cygwin64
        echo - C:\tools\cygwin
        GOTO END
    )
)

@IF "%1"=="" GOTO NO_PARAM
@IF "%1"=="-b" GOTO BUILD
@IF "%1"=="-u" GOTO UPLOAD
@IF "%1"=="-m" GOTO BUILD
echo %1
@GOTO WRONG_PARAM

:BUILD

set "origin=%2%"

del /q C:\RB3rt\sdk\workspace\app
del /q C:\RB3rt\sdk\workspace\project\*

xcopy /y/q %origin%\* C:\RB3rt\sdk\workspace\project

IF "%1"=="-m" GOTO MAKE

%cygwin%\bin\bash.exe -l -c " pwd ; cd /cygdrive/c/RB3rt/sdk/workspace ; pwd ; make app=project"
xcopy /y C:\RB3rt\sdk\workspace\app %origin%\.

GOTO END

:MAKE
%cygwin%\bin\bash.exe -l -c " pwd ; cd /cygdrive/c/RB3rt/sdk/workspace ; pwd ; make app=project && make upload"
GOTO END


:UPLOAD
%cygwin%\bin\bash.exe -l -c " pwd ; cd /cygdrive/c/RB3rt/sdk/workspace ; pwd ; make upload"

GOTO END


:NO_PARAM
echo "%0: no parameters"
GOTO END

:WRONG_PARAM
echo "%0: wrong parameters"
:END