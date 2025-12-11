@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Usage: set-org-id.bat YOUR-ANYPOINT-ORG-ID
if "%~1"=="" (
  set /p ORG_ID=Enter your Anypoint Org ID (UUID): 
) else (
  set ORG_ID=%~1
)

if "%ORG_ID%"=="" (
  echo Org ID is required. Aborting.
  exit /b 1
)

REM Update all POM files with the provided Org ID
powershell -NoProfile -ExecutionPolicy Bypass ^
  "$orgId = '%ORG_ID%';" ^
  "$patterns = @(" ^
  "  '(?<=<groupId>)[0-9a-fA-F-]{36}(?=</groupId>)'," ^
  "  '(?<=<student\.deployment\.ap\.orgid>)[0-9a-fA-F-]{36}(?=</student\.deployment\.ap\.orgid>)'," ^
  "  '(?<=<new\.ap\.org\.id>)[0-9a-fA-F-]{36}(?=</new\.ap\.org\.id>)'" ^
  ");" ^
  "$files = @('bom/pom.xml','parent-pom/pom.xml','apps-commons/pom.xml','check-in-papi/pom.xml','paypal-sapi/pom.xml','paypal-sapi/pom-ci.xml');" ^
  "foreach ($f in $files) {" ^
  "  if (-not (Test-Path $f)) { Write-Warning \"Missing file: $f\"; continue }" ^
  "  $text = Get-Content $f -Raw;" ^
  "  foreach ($pat in $patterns) { $text = [regex]::Replace($text, $pat, $orgId) }" ^
  "  Set-Content -Path $f -Value $text -NoNewline;" ^
  "  Write-Host \"Updated $f\";" ^
  "}" ^
  "Write-Host 'Done.'"

endlocal
