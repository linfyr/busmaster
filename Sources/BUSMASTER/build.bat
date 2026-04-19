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
cmake -G "Visual Studio 17 2022" -A Win32 .. >nul 2>&1
if not errorlevel 1 goto COMPILE

cmake -G "Visual Studio 16 2019" -A Win32 .. >nul 2>&1
if not errorlevel 1 goto COMPILE

cmake -G "Visual Studio 12 2013" .. >nul 2>&1
if not errorlevel 1 goto COMPILE

cmake -G "Visual Studio 11 2012" -T "v110_xp" ..
if errorlevel 1 goto VS_NOT_FOUND

REM automatically compile solution:
:COMPILE
MSBuild "BUSMASTER.sln" /property:Configuration=Release /p:Platform=Win32

:VS_NOT_FOUND
echo Supported Visual Studio generator not found. Build failed!
goto END

:END
REM pause
exit 0
