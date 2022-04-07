ECHO off

SET /P GITHUB_RUN_NUMBER=Please enter a build number (e.g. 134):
SET /P PACKAGE_VERSION=Please enter your package version (e.g. 1.0.5):
SET /P UMBRACO_PACKAGE_PRERELEASE_SUFFIX=Please enter your package release suffix or leave empty (e.g. beta):

SET /P GITHUB_REF_TYPE=If you want to simulate a GitHub tag for a release (e.g. tag):

if "%GITHUB_RUN_NUMBER%" == "" (
  SET GITHUB_RUN_NUMBER=100
)
if "%PACKAGE_VERSION%" == "" (
  SET PACKAGE_VERSION=0.1.0
)

SET APPVEYOR_BUILD_VERSION=%PACKAGE_VERSION%.%APPVEYOR_BUILD_NUMBER%

if "%GITHUB_REF_TYPE%" == "tag" (
	SET MERCHELLO_VERSION = %PACKAGE_VERSION%
) else (
	SET MERCHELLO_VERSION = %APPVEYOR_BUILD_VERSION%
)



if exist ".\src\Merchello.Web.UI\App_Plugins\Merchello" (
	RMDIR /S /Q ".\src\Merchello.Web.UI\App_Plugins\Merchello"
)

CALL build-grunt.cmd

build-appveyor.cmd

@IF %ERRORLEVEL% NEQ 0 GOTO err
@EXIT /B 0
:err
@PAUSE
@EXIT /B 1