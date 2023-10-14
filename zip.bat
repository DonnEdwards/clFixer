@echo off
@echo [%1]
@echo [%2]
@echo [%3]
@echo [%4]
rem learn-2021-04-20
if %1. == . Goto END
rem ZIPPY=clfixer
rem MSG=Preparing to backup clFixer files
rem PAUSE=5
F:
@echo ----------------------------------[%time%]-------------------------------
echo Backup files up to %1 ...
F:
cd F:\dev\clfixer
for %%f in (*.tmp,*.gz) do del "%%f"
rem echo Copying debug runtime
rem copy C:\Clarion11.1\bin\debug\ClaRUN.dll
echo Copying production runtime
copy C:\Clarion11.1\bin\ClaRUN.dll
@echo ----------------------------------[%time%]-------------------------------
echo Moving old zip files to the zip folder
if not exist .\zip\nul md .\zip 
if exist *.zip move *.zip .\zip
rem copy today's zip file back
if exist .\zip\%1-%3.zip copy .\zip\%1-%3.zip
if exist .\zip\%1.zip copy .\zip\%1.zip
echo+
@echo ----------------------------------[%time%]-------------------------------
C:\Clarion11.1\bin\7z.exe a -tzip -spf2 %1-%3.zip *.a* *.b* *.c* *.d* *.e* *.g* *.i* *.j* *.l* *.r* *.pem *.png *.sl* *.sh* *.t* *.x* *.Version -x!*.ap~
rem "C:\Program Files\PKWARE\PKZIPC\pkzipc.exe" -add=update -nofix -path=root %1-%3 *.a* *.b* *.c* *.d* *.e* *.g* *.i* *.j* *.l* *.r* *.pem *.png *.sl* *.sh* *.t* *.x* *.Version 
rem WEB folder exists if you are using NetTalk
if not exist web\nul goto DONE
C:\Clarion11.1\bin\7z.exe a -tzip -spf2 %1.zip -ir!web\*.* -xr!*.zip
echo+
:DONE
@echo ----------------------------------[%time%]-------------------------------
rem Compress the EXE to save space
"C:\Clarion11.1\accessory\bin\upx.exe" clfixer.exe
rem "C:\Clarion11.1\accessory\bin\upx.exe" *.dll
copy clfixer.exe .\install\*.*
@echo ----------------------------------[%time%]-------------------------------
move *.zip .\zip
echo+
echo *Close* this window to run the app. 
echo To delete old OBJ and MAP files, press any key ...
pause > nul
for %%f in (.\obj\release\*.*,.\map\release\*.*,.\obj\debug\*.*,.\map\debug\*.*,clfixer*.ini,.\dctx\*.cl.temp) do del "%%f"
exit
