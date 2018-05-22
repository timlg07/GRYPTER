::++HEADER
@call :setTitle "GRYPTWRITER" >nul
@echo off
@color 0c
@goto MAIN
::--HEADER

::++MAIN_Programm

:MAIN
	call :setTitle "GRYPTWRITER [MAIN MENU]"
	echo/^>
	echo/^>    MAIN MENU
	echo/^>
	echo/^>    [E]NCRYPT
	echo/^>    [D]ECRYPT
	echo/^>
	echo;|set/P"=>    "
	CHOICE /C ED /N
	if %errorlevel% EQU 1 set action=encrypt
	if %errorlevel% EQU 2 set action=decrypt
	call :getPassword pw_sum
	call :getFileName srcFil
	goto :%action%
exit

:ENCRYPT
	call :setTitle "GRYPTWRITER [ENCRYPT]"
	setlocal enableDelayedExpansion
		cls
		echo/^>
		echo/^>    YOUR TEXT:
		echo/^>
		echo/^>
		
		set "x=4"
		set "y=3"
		set "c= "
		
		:WHILE_2
			batbox /K
			set "code=%errorlevel%"
			batbox /g %x% %y% /d "%c%"
			set /a x+=1
			set "c=*"
			batbox /g !x! !y! /a %code%
			set /a value=code+pw_sum
			::batbox /d "!value!;" >> %srcFil%
			echo+!value!>>%srcFil%
			
			if %code% NEQ 13 goto :WHILE_2
			set /a y+=1
			set /a x=4
			set   "c= "
			batbox /g %x% %y% /d "[S]TOP / [C]ONTINUE > "
			CHOICE /c sc /n 
			if %errorlevel% EQU 1 goto stop
			batbox /g 0 %y% /d ">                                  "
		goto WHILE_2
	endlocal
exit

:DECRYPT
	call :setTitle "GRYPTWRITER [DECRYPT]"
	setlocal enableDelayedExpansion
		
		if not exist "%srcFil%" (
			echo/^>    FILE "%srcFil%" DOES NOT EXIST.
			echo/^>    Any key to slelect file again.
			pause>nul
			endlocal & call :getFileName srcFil & goto :DECRYPT
		)
		
		cls
		
		echo/^>  +----------------------+
		echo/^>  ^|                      ^|
		echo/^>  ^|   DECRYPTED TEXT:    ^|
		echo/^>  ^|                      ^|
		echo/^>  +----------------------+
		echo/^>
		batbox /d ">    "
		
		for /F "usebackq" %%N in ("%srcFil%") do (
			set /a "value=%%N-pw_sum"
			if !value! EQU 13 ( 
				echo+
				batbox /d ">    "
			) else (
				batbox /A !value! /w 8
			)
		)
		
		echo/^>
		echo/^>
		echo/^>  +----------END----------+
		echo/^>        press any key.     
		pause>nul
	endlocal
goto stop

:stop
	call :setTitle "GRYPTWRITER [FINISHED]"
	endlocal
	cls
	echo/^>
	echo/^>    FINISHED.
	echo/^>
	pause >nul
%0
::--MAIN_Programm



::++additionalFUNCTIONS

:setTitle
	set "title=%~1"
	title %title%
exit /B 0

:getPassword
	call :setTitle "GRYPTWRITER [PASSWORD]"
	setlocal
		cls
		set "sum=0"
		echo/^>
		echo/^>    PASSWORD:
		echo;|set/P"=>    "
		:WHILE_1
			batbox /K
			if %errorlevel% NEQ 13 (
				set /A sum+=%errorlevel%
				echo;|set/P"=*"
				goto :WHILE_1
			)
	endlocal & set "%~1=%sum%"
exit /B 0

:getFileName
	call :setTitle "GRYPTWRITER [FILENAME]"
	setlocal
		cls
		echo/^>
		echo/^>    FILE NAME:
		set/P"input=>    "
	endlocal & set "%~1=%input%"
exit /B 0

::--additionalFUNCTIONS






