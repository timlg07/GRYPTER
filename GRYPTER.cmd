::++HEADER
@call :setTitle "GRYPTER" >nul
@echo off
@color 0c
@goto MAIN
::--HEADER

::++MAIN_Programm

:MAIN
	call :setTitle "GRYPTER [MAIN MENU]"
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

::++ENCRYPT

:ENCRYPT
	call :setTitle "GRYPTER [ENCRYPT]"
	setlocal enableDelayedExpansion
		cls
		echo/^>
		echo/^>    ENCRYPTING...
		echo/^>
		echo/^>
		echo/^>
		
		set "destFile=TMP.GRYPT"
		
		set /A "lineCount=0"
		for /F "tokens=* delims=" %%L in (%srcFil%) do (
			set /A lineCount+=1
			batbox /g 5 3 /d "line:!lineCount!"
			call :ENCRYPT_LINE "%%L"
			::newLine::
			set /a value=13+pw_sum
			echo:!value!>>%destFile%
			set /a value=10+pw_sum
			echo:!value!>>%destFile%
		)
		
		del "%srcFil%"
		ren "%destFile%" "%srcFil%"


	endlocal
goto stop

	:ENCRYPT_LINE
		set /a "pos=0"
		set "string=%~1"
		:ENCRYPT_CHAR
			batbox /g 5 4 /d "letter:%pos% "
			call :GET_CODE "!string:~%pos%,1!"
			set /a value=return+pw_sum
			echo:%value%>>%destFile%
			set /a pos+=1
			if "!string:~%pos%,1!" NEQ "" goto ENCRYPT_CHAR
		exit /B
	exit /B

	:GET_CODE
		echo[[^%~1]  
		setlocal enableDelayedExpansion
			for /L %%i in (0, 1, 255) do (
				cmd /c exit /b %%i
				set char=^!=ExitCodeAscii!
				if [^!char!]==[^%~1] endlocal & set "return=%%i" & exit /B 0
			)
		endlocal & (
			set return=0
		)
	exit /B 1	

::--ENCRYPT

::++DECRYPT

:DECRYPT
	call :setTitle "GRYPTER [DECRYPT]"
	setlocal enableDelayedExpansion
		cls
		echo/^>
		echo/^>    DECRYPTING...
		echo/^>
		echo/^>
		echo/^>
		
		set "destFile=TMP.GRYPT"
		set /A "lineCount=0"
		set /A "charCount=0"
		for /F "usebackq" %%N in ("%srcFil%") do (
			set /a "value=%%N-pw_sum"
			set /A charCount+=1
			batbox /g 5 4 /d "letter:!charCount!"
			batbox /A !value! >>%destFile%
			if !value! EQU 13 (
				batbox /A 10 
				set /A lineCount+=1
				set /A charCount =0
				batbox /g 5 3 /d "line:!lineCount!"
			)
		)
		
		del "%srcFil%"
		ren "%destFile%" "%srcFil%"
		
	endlocal
goto stop

::--ENCRYPT

:stop
	call :setTitle "GRYPTER [FINISHED]"
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
	call :setTitle "GRYPTER [PASSWORD]"
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
	cls
exit /B 0

:getFileName
	call :setTitle "GRYPTER [FILENAME]"
	setlocal
		echo/^>
		echo/^>    FILE NAME:
		set/P"input=>    "
		if not exist "%input%" (
			echo/^>    FILE "%input%" DOES NOT EXIST.
			goto getFileName
		)
	endlocal & set "%~1=%input%"
exit /B 0

::--additionalFUNCTIONS






