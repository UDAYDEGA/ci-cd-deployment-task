@echo off
setlocal

REM ==========================================
REM COMMON VALUES
REM ==========================================

set ANYPOINT_USERNAME=~Client~
set ANYPOINT_PASSWORD=YOUR_CONNECTED_APP_SECRET
set BUSINESS_GROUP=YOUR_BUSINESS_GROUP

REM ==========================================
REM DEPLOY TO SANDBOX
REM ==========================================

echo Deploying to SANDBOX...

call mvn clean deploy ^
--settings .maven/settings.xml ^
-DskipMunitTests ^
-DmuleDeploy ^
-Danypoint.username=%ANYPOINT_USERNAME% ^
-Danypoint.password=%ANYPOINT_PASSWORD% ^
-Danypoint.businessGroup=%BUSINESS_GROUP% ^
-Dplatform.client_id=SANDBOX_CLIENT_ID ^
-Dplatform.client_secret=SANDBOX_CLIENT_SECRET ^
-Denv=Sandbox

IF %ERRORLEVEL% NEQ 0 (
    echo Sandbox Deployment Failed
    exit /b 1
)

REM ==========================================
REM DEPLOY TO DEV
REM ==========================================

echo Deploying to DEV...

call mvn deploy ^
--settings .maven/settings.xml ^
-DskipMunitTests ^
-DmuleDeploy ^
-Danypoint.username=%ANYPOINT_USERNAME% ^
-Danypoint.password=%ANYPOINT_PASSWORD% ^
-Danypoint.businessGroup=%BUSINESS_GROUP% ^
-Dplatform.client_id=DEV_CLIENT_ID ^
-Dplatform.client_secret=DEV_CLIENT_SECRET ^
-Denv=Dev

IF %ERRORLEVEL% NEQ 0 (
    echo Dev Deployment Failed
    exit /b 1
)

REM ==========================================
REM DEPLOY TO QA
REM ==========================================

echo Deploying to QA...

call mvn deploy ^
--settings .maven/settings.xml ^
-DskipMunitTests ^
-DmuleDeploy ^
-Danypoint.username=%ANYPOINT_USERNAME% ^
-Danypoint.password=%ANYPOINT_PASSWORD% ^
-Danypoint.businessGroup=%BUSINESS_GROUP% ^
-Dplatform.client_id=QA_CLIENT_ID ^
-Dplatform.client_secret=QA_CLIENT_SECRET ^
-Denv=QA

IF %ERRORLEVEL% NEQ 0 (
    echo QA Deployment Failed
    exit /b 1
)

REM ==========================================
REM DEPLOY TO PRODUCTION
REM ==========================================

echo Deploying to PRODUCTION...

call mvn deploy ^
--settings .maven/settings.xml ^
-DskipMunitTests ^
-DmuleDeploy ^
-Danypoint.username=%ANYPOINT_USERNAME% ^
-Danypoint.password=%ANYPOINT_PASSWORD% ^
-Danypoint.businessGroup=%BUSINESS_GROUP% ^
-Dplatform.client_id=PROD_CLIENT_ID ^
-Dplatform.client_secret=PROD_CLIENT_SECRET ^
-Denv=Production

IF %ERRORLEVEL% NEQ 0 (
    echo Production Deployment Failed
    exit /b 1
)

echo ==========================================
echo ALL ENVIRONMENTS DEPLOYED SUCCESSFULLY
echo ==========================================

pause
