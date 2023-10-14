@echo off
for %%f in (clfixer.ini?) do del %%f
pskill -t clfixer.exe
pskill -t DebugView.exe
pslist > nul
