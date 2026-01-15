@echo off
REM Refactor Split Bill Utility Pages to Use Partial Components
REM This script replaces hardcoded head sections with load tags

setlocal enabledelayedexpansion

echo.
echo ============================================
echo    Split Bill Pages Refactoring Script
echo ============================================
echo.

set "pages=sira_split_bill_utility_1 sira_split_bill_utility_2 sira_split_bill_utility_3 sira_split_bill_utility_4 sira_split_bill_utility_5"

for %%p in (%pages%) do (
    call :refactor_page "%%p"
)

echo.
echo ============================================
echo    Refactoring Complete!
echo ============================================
echo.
echo Summary:
echo   - Replaced hardcoded head sections with load tags
echo   - Preserved unique styles for each page
echo   - Created backups with .backup extension
echo.
echo Next steps:
echo   1. Review the changes: git diff
echo   2. Test the pages in the browser
echo   3. If satisfied, commit the changes
echo   4. Remove backups if not needed
echo.
pause
goto :eof

:refactor_page
set "page_dir=%~1"
set "page_file=%page_dir%\code.html"

echo Processing: %page_file%

if not exist "%page_file%" (
    echo   ERROR: File not found: %page_file%
    goto :eof
)

REM Create backup
copy "%page_file%" "%page_file%.backup" >nul

REM Determine title
set "title=Sira - Split Bill"
echo %page_dir% | findstr "utility_2" >nul
if %errorlevel%==0 set "title=Sira - Data Importer Center"

REM Create header
(
echo ^<!DOCTYPE html^>
echo ^<html class="light" lang="en"^>
echo   ^<head^>
echo     ^<load src="/src/partials/head.html" title="%title%" /^>
echo     ^<style^>
echo       ::-webkit-scrollbar {
echo         width: 6px;
echo         height: 6px;
echo       }
echo       ::-webkit-scrollbar-track {
echo         background: transparent;
echo       }
echo       ::-webkit-scrollbar-thumb {
echo         background: #cbd5e1;
echo         border-radius: 3px;
echo       }
echo       ::-webkit-scrollbar-thumb:hover {
echo         background: #94a3b8;
echo       }
echo       .glass-panel {
echo         background: rgba(255, 255, 255, 0.65^);
echo         backdrop-filter: blur(12px^);
echo         -webkit-backdrop-filter: blur(12px^);
echo         border: 1px solid rgba(255, 255, 255, 0.6^);
echo       }
echo       .glass-card {
echo         background: rgba(255, 255, 255, 0.85^);
echo         backdrop-filter: blur(8px^);
echo         border: 1px solid rgba(255, 255, 255, 0.8^);
echo         box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03^);
echo       }
echo       .toggle-checkbox:checked {
echo         right: 0;
echo         border-color: #52e0d4;
echo       }
echo       .toggle-checkbox:checked + .toggle-label {
echo         background-color: #52e0d4;
echo       }
echo       .flux-gradient {
echo         background: linear-gradient(135deg, #52e0d4 0%%, #22d3ee 100%%^);
echo       }
echo       .bg-blob {
echo         position: absolute;
echo         filter: blur(80px^);
echo         z-index: 0;
echo         opacity: 0.4;
echo       }
) > "%page_file%.tmp"

REM Add matrix styles for utility_3
echo %page_dir% | findstr "utility_3" >nul
if %errorlevel%==0 (
    (
    echo       .matrix-checkbox:checked + .avatar-ring {
    echo         border-color: #52e0d4;
    echo         background-color: rgba(82, 224, 212, 0.1^);
    echo       }
    echo       .matrix-checkbox:checked + .avatar-ring img {
    echo         opacity: 1;
    echo         filter: grayscale(0^);
    echo       }
    echo       .matrix-checkbox:not(:checked^) + .avatar-ring img {
    echo         opacity: 0.4;
    echo         filter: grayscale(1^);
    echo       }
    ) >> "%page_file%.tmp"
)

REM Close style and head
(
echo     ^</style^>
echo   ^</head^>
) >> "%page_file%.tmp"

REM Find where head ends and copy the rest
powershell -Command "$content = Get-Content '%page_file%'; $headEnd = ($content | Select-String -Pattern '</head>' | Select-Object -First 1).LineNumber; if ($headEnd) { $content[$headEnd..($content.Length-1)] | Out-File '%page_file%.body' -Encoding UTF8 }"

REM Append body content
type "%page_file%.body" >> "%page_file%.tmp"
del "%page_file%.body"

REM Replace original with new version
move /y "%page_file%.tmp" "%page_file%" >nul

echo   SUCCESS: Refactored %page_file%
echo.

goto :eof
