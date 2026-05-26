@echo off
setlocal enabledelayedexpansion

echo ============================================
echo   MuleSoft Deploy - All Environments
echo ============================================

REM ─── CONNECTED APP (same for all envs) ───────
set ANYPOINT_USERNAME=~~~Client~~~
set ANYPOINT_PASSWORD=2b1c4d76f7b048bd8da9daec9b2338aa~?~D1C962f95d8c4EF5818350d130fC9189
set CONNECTED_APP_CLIENT_ID=2b1c4d76f7b048bd8da9daec9b2338aa
set CONNECTED_APP_CLIENT_SECRET=D1C962f95d8c4EF5818350d130fC9189
set BUSINESS_GROUP=efeadf51-7191-4c48-805e-af0726859475

REM ─── PLATFORM CLIENT ID/SECRET PER ENV ───────
REM IMPORTANT: Names must EXACTLY match Anypoint Portal
REM Check: anypoint.mulesoft.com > Access Management > Environments

set PLATFORM_CLIENT_ID_Sandbox=6725d299b67b4198bc9a2fa7d40bf5c5
set PLATFORM_CLIENT_SECRET_Sandbox=e23adfAAF04048A386800dA54161931C

set PLATFORM_CLIENT_ID_Design=1d3a3581e5954ec2aa5396ecd1e4eaeb
set PLATFORM_CLIENT_SECRET_Design=D2Ed9A9D6633471fA507C4bcaABf45B3

set PLATFORM_CLIENT_ID_Dev=f4b12eae8e2f486798addea2e84b599b
set PLATFORM_CLIENT_SECRET_Dev=4108f97afc60488b8174c0Cd5A7BD239

REM Change UAT to exactly match your Anypoint env name (UAT / Uat / uat)
set PLATFORM_CLIENT_ID_UAT=e94aa625d8ce451bac0bbede47ef51ec
set PLATFORM_CLIENT_SECRET_UAT=00adfA4e1C1447FaA3632bfc3459fb4A
REM ─────────────────────────────────────────────

REM ── Step 1: Publish to Anypoint Exchange ─────
echo.
echo [1/5] Publishing to Anypoint Exchange...
echo -----------------------------------------
call mvn deploy --settings .maven/settings.xml -DskipMunitTests ^
  -Danypoint.username="%ANYPOINT_USERNAME%" ^
  -Danypoint.password="%ANYPOINT_PASSWORD%"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Exchange publish failed. Stopping.
    exit /b 1
)
echo SUCCESS: Published to Exchange.

REM ── Steps 2-5: Deploy each env in order ──────
call :DEPLOY_ENV Sandbox
if %ERRORLEVEL% NEQ 0 exit /b 1

call :DEPLOY_ENV Design
if %ERRORLEVEL% NEQ 0 exit /b 1

call :DEPLOY_ENV Dev
if %ERRORLEVEL% NEQ 0 exit /b 1

call :DEPLOY_ENV UAT
if %ERRORLEVEL% NEQ 0 exit /b 1

echo.
echo ============================================
echo   ALL ENVIRONMENTS DEPLOYED SUCCESSFULLY
echo ============================================
exit /b 0


REM ─── FUNCTION: deploy to one environment ─────
:DEPLOY_ENV
set ENV_NAME=%1
set CLIENT_ID=!PLATFORM_CLIENT_ID_%ENV_NAME%!
set CLIENT_SECRET=!PLATFORM_CLIENT_SECRET_%ENV_NAME%!

echo.
echo [DEPLOY] %ENV_NAME%...
echo -----------------------------------------
call mvn deploy --settings .maven/settings.xml -DskipMunitTests -DmuleDeploy ^
  -Danypoint.username="%ANYPOINT_USERNAME%"                   ^
  -Danypoint.password="%ANYPOINT_PASSWORD%"                   ^
  -Dconnected.app.client_id="%CONNECTED_APP_CLIENT_ID%"       ^
  -Dconnected.app.client_secret="%CONNECTED_APP_CLIENT_SECRET%" ^
  -Danypoint.businessGroup="%BUSINESS_GROUP%"                 ^
  -Dplatform.client_id="%CLIENT_ID%"                          ^
  -Dplatform.client_secret="%CLIENT_SECRET%"                  ^
  -Denv="%ENV_NAME%"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Deployment to %ENV_NAME% FAILED.
    exit /b 1
)
echo SUCCESS: Deployed to %ENV_NAME%.
exit /b 0
