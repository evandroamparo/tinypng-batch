@echo off

setlocal

:: you can get APIKEY from https://tinypng.com/developers
:: set TINYPNG_APIKEY=
 
:: if set prefix or (and) suffix, not overwrite original file.
set PREFIX=
set SUFFIX=

for /f "tokens=2 delims=)" %%i in ('dir *.jpg *.png ^| grep -r+ "bytes$"') do @set before=%%i
 
for %%p in ( *.png,*.jpg ) do (
  echo.
  echo Compressing %%p...	
  for /f "tokens=1,2 usebackq" %%j in ( `curl -k -i -# --user api:%TINYPNG_APIKEY% --data-binary @"%%p" https://api.tinypng.com/shrink` ) do (
    if "%%j"=="Location:" curl --user api:%TINYPNG_APIKEY% --header "Content-Type: application/json" --data "{\"preserve\": [\"copyright\", \"location\", \"creation\"]}" -k %%k -# > %PREFIX%%%p%SUFFIX%
  )
)

for /f "tokens=2 delims=)" %%i in ('dir *.jpg *.png ^| grep -r+ "bytes$"') do @set after=%%i

echo Before: %before%
echo After: %after%
