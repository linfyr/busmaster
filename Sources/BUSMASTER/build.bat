@echo off

:DOTNET_SEARCH
set DOTNET=%SystemRoot%\Microsoft.NET\Framework\v4.0.30319
if exist "%DOTNET%\MSBuild.exe" goto DOTNET_FOUND

set DOTNET=%SystemRoot%\Microsoft.NET\Framework\v3.5
if exist "%DOTNET%\MSBuild.exe" goto DOTNET_FOUND

:DOTNET_NOT_FOUND
echo .NET Framework not found. Build failed!
goto END

:DOTNET_FOUND
echo Using MSBuild found in %DOTNET%

:CMAKE_SEARCH
set CMAKE=%ProgramFiles%\CMake\bin
if exist "%CMAKE%\cmake.exe" goto CMAKE_FOUND

:CMAKE_NOT_FOUND
echo CMake not found. Build failed!
goto END

:CMAKE_FOUND
echo Using CMake found in %CMAKE%

:BUILD
set PATH=%CMAKE%;%DOTNET%;%PATH%
REM define your build directory here:
mkdir build
cd build

REM define your compiler/IDE here:
set CMAKE_LOG=%CD%\cmake-configure.log
echo Trying Visual Studio 17 2022 generator > "%CMAKE_LOG%"
cmake -G "Visual Studio 17 2022" -A Win32 .. >> "%CMAKE_LOG%" 2>&1
if %ERRORLEVEL% EQU 0 goto COMPILE

echo Trying Visual Studio 16 2019 generator >> "%CMAKE_LOG%"
cmake -G "Visual Studio 16 2019" -A Win32 .. >> "%CMAKE_LOG%" 2>&1
if %ERRORLEVEL% EQU 0 goto COMPILE

echo Trying Visual Studio 12 2013 generator >> "%CMAKE_LOG%"
cmake -G "Visual Studio 12 2013" .. >> "%CMAKE_LOG%" 2>&1
if %ERRORLEVEL% EQU 0 goto COMPILE

echo Trying Visual Studio 11 2012 generator >> "%CMAKE_LOG%"
cmake -G "Visual Studio 11 2012" -T "v110_xp" .. >> "%CMAKE_LOG%" 2>&1
if %ERRORLEVEL% NEQ 0 goto VS_NOT_FOUND

REM automatically compile solution:
:COMPILE
MSBuild "BUSMASTER.sln" /p:Configuration=Release
goto END

:VS_NOT_FOUND
echo Supported Visual Studio generator not found. Build failed!
echo See "%CMAKE_LOG%" for details.
goto END

:END
REM pause
exit 0
