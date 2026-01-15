# Refactor Split Bill Utility Pages to Use Partial Components
# PowerShell Script

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   Split Bill Pages Refactoring Script" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

$pages = @(
    "sira_split_bill_utility_1",
    "sira_split_bill_utility_2",
    "sira_split_bill_utility_3",
    "sira_split_bill_utility_4",
    "sira_split_bill_utility_5"
)

function Refactor-Page {
    param (
        [string]$PageDir
    )
    
    $pageFile = Join-Path $PageDir "code.html"
    
    Write-Host "  Processing: $pageFile" -ForegroundColor Yellow
    
    if (-not (Test-Path $pageFile)) {
        Write-Host "    ERROR: File not found: $pageFile" -ForegroundColor Red
        return
    }
    
    # Create backup
    Copy-Item $pageFile "$pageFile.backup" -Force
    
    # Determine title
    $title = "Sira - Split Bill"
    if ($PageDir -match "utility_2") {
        $title = "Sira - Data Importer Center"
    }
    
    # Read original file
    $content = Get-Content $pageFile -Raw
    
    # Find where </head> ends
    $headEndIndex = $content.IndexOf("</head>")
    if ($headEndIndex -eq -1) {
        Write-Host "    ERROR: Could not find </head> tag" -ForegroundColor Red
        return
    }
    
    # Get body content (everything after </head>)
    $bodyContent = $content.Substring($headEndIndex + 7)
    
    # Build new head section
    $newHead = @"
<!DOCTYPE html>
<html class="light" lang="en">
  <head>
    <load src="/src/partials/head.html" title="$title" />
    <style>
      ::-webkit-scrollbar {
        width: 6px;
        height: 6px;
      }
      ::-webkit-scrollbar-track {
        background: transparent;
      }
      ::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 3px;
      }
      ::-webkit-scrollbar-thumb:hover {
        background: #94a3b8;
      }
      .glass-panel {
        background: rgba(255, 255, 255, 0.65);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.6);
      }
      .glass-card {
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(8px);
        border: 1px solid rgba(255, 255, 255, 0.8);
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
      }
      .toggle-checkbox:checked {
        right: 0;
        border-color: #52e0d4;
      }
      .toggle-checkbox:checked + .toggle-label {
        background-color: #52e0d4;
      }
      .flux-gradient {
        background: linear-gradient(135deg, #52e0d4 0%, #22d3ee 100%);
      }
      .bg-blob {
        position: absolute;
        filter: blur(80px);
        z-index: 0;
        opacity: 0.4;
      }
"@

    # Add matrix styles for utility_3
    if ($PageDir -match "utility_3") {
        $newHead += @"

      .matrix-checkbox:checked + .avatar-ring {
        border-color: #52e0d4;
        background-color: rgba(82, 224, 212, 0.1);
      }
      .matrix-checkbox:checked + .avatar-ring img {
        opacity: 1;
        filter: grayscale(0);
      }
      .matrix-checkbox:not(:checked) + .avatar-ring img {
        opacity: 0.4;
        filter: grayscale(1);
      }
"@
    }
    
    $newHead += @"

    </style>
  </head>
"@
    
    # Combine new head with original body
    $newContent = $newHead + $bodyContent
    
    # Write to file
    Set-Content -Path $pageFile -Value $newContent -NoNewline -Encoding UTF8
    
    Write-Host "    SUCCESS: Refactored successfully" -ForegroundColor Green
    Write-Host ""
}

# Process each page
foreach ($page in $pages) {
    Refactor-Page -PageDir $page
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Refactoring Complete!" -ForegroundColor Green
Write-Host "============================================`n" -ForegroundColor Cyan

Write-Host "Summary:" -ForegroundColor White
Write-Host "  - Replaced hardcoded <head> sections with <load> tags"
Write-Host "  - Preserved unique styles for each page"
Write-Host "  - Created backups with .backup extension`n"

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review the changes: git diff"
Write-Host "  2. Test the pages in the browser"
Write-Host "  3. If satisfied, commit: git add . && git commit -m 'refactor: implement partials in split bill pages'"
Write-Host "  4. Remove backups: Remove-Item **/code.html.backup`n"
