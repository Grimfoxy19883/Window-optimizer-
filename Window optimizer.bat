
@echo off
rem Deleting files in %temp%
del /q "%USERPROFILE%\AppData\Local\Temp\*.*"

rem Deleting files in C:\Windows\Temp
del /q "C:\Windows\Temp\*.*" 

echo Temporary files and folders deleted successfully.

REM Change power plan settings
powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-ac 0
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

echo Power plan changed successfully.

REM Enable all cores
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value') do set cores=%%a
for /f "tokens=2 delims==" %%b in ('wmic cpu get NumberOfLogicalProcessors /value') do set threads=%%b

if %threads% gtr %cores% (
    set cores=%threads%
)

echo Number of cores: %cores%
echo Number of threads: %threads%

bcdedit /set numproc %cores%

echo All cores enabled successfully.
echo Cleanup finished!
echo Checking System Integrity and Repairs. This may take long
cleanmgr /autoclean

ChkDsk /f
Sfc /ScanNow
REM Download Memreduct
set downloadUrl=https://github.com/henrypp/memreduct/releases/download/v.3.4/memreduct-3.4-setup.exe
set downloadFolder=%CD%\Downloads

echo Downloading Memreduct...
mkdir "%downloadFolder%" 2>nul
bitsadmin /transfer "MemreductDownload" %downloadUrl% "%downloadFolder%\memreduct-3.4-setup.exe"
echo Memreduct downloaded successfully.

echo Installing Memreduct...
powershell Start-Process -FilePath "%downloadFolder%\memreduct-3.4-setup.exe" -ArgumentList "/S" -Wait
echo Memreduct installed successfully.

