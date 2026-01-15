# Complete Refactoring Script for Split Bill Pages
# Uses existing sidebar.html and header.html partials

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   Split Bill Complete Refactoring" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

$pages = @(
    @{ Dir = "sira_split_bill_utility_1"; Title = "Sira - Split Bill"; HeaderTitle = "New Split Session"; HeaderSubtitle = "Collaborative billing"; HeaderIcon = "receipt_long"; Active = "split-bill" },
    @{ Dir = "sira_split_bill_utility_2"; Title = "Sira - Data Importer"; HeaderTitle = "Import Data"; HeaderSubtitle = "Upload bank statements"; HeaderIcon = "upload_file"; Active = "split-bill" },
    @{ Dir = "sira_split_bill_utility_3"; Title = "Sira - Split Bill Matrix"; HeaderTitle = "Split Matrix"; HeaderSubtitle = "Visual bill splitting"; HeaderIcon = "grid_on"; Active = "split-bill" },
    @{ Dir = "sira_split_bill_utility_4"; Title = "Sira - Split Bill"; HeaderTitle = "New Split Session"; HeaderSubtitle = "Two-column layout"; HeaderIcon = "receipt_long"; Active = "split-bill" },
    @{ Dir = "sira_split_bill_utility_5"; Title = "Sira - Data Importer"; HeaderTitle = "Import Data"; HeaderSubtitle = "Review transactions"; HeaderIcon = "upload_file"; Active = "split-bill" }
)

function Refactor-SplitBillPage {
    param (
        [hashtable]$PageInfo
    )
    
    $pageFile = Join-Path $PageInfo.Dir "code.html"
    
    Write-Host "  Processing: $pageFile" -ForegroundColor Yellow
    
    if (-not (Test-Path $pageFile)) {
        Write-Host "    ERROR: File not found" -ForegroundColor Red
        return
    }
    
    # Read original file
    $content = Get-Content $pageFile -Raw
    
    # Find the </head> tag
    $headEndIndex = $content.IndexOf("</head>")
    if ($headEndIndex -eq -1) {
        Write-Host "    ERROR: Could not find </head> tag" -ForegroundColor Red
        return
    }
    
    # Find where the sidebar starts (after <body>)
    $sidebarStartIndex = $content.IndexOf("<aside", $headEndIndex)
    if ($sidebarStartIndex -eq -1) {
        Write-Host "    ERROR: Could not find sidebar" -ForegroundColor Red
        return
    }
    
    # Find where the sidebar ends
    $sidebarEndIndex = $content.IndexOf("</aside>", $sidebarStartIndex) + 8
    
    # Find where the header starts (after <main>)
    $headerStartIndex = $content.IndexOf("<header", $sidebarEndIndex)
    if ($headerStartIndex -eq -1) {
        Write-Host "    ERROR: Could not find header" -ForegroundColor Red
        return
    }
    
    # Find where the header ends
    $headerEndIndex = $content.IndexOf("</header>", $headerStartIndex) + 9
    
    # Get the content after header (main content)
    $mainContent = $content.Substring($headerEndIndex)
    
    # Build new file structure
    $newContent = @"
<!DOCTYPE html>
<html class="light" lang="en">
  <head>
    <load src="/src/partials/head.html" title="$($PageInfo.Title)" />
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
    if ($PageInfo.Dir -eq "sira_split_bill_utility_3") {
        $newContent += @"

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
    
    $newContent += @"

    </style>
  </head>
  <body class="bg-background-light text-[#21262c] font-display h-screen flex overflow-hidden selection:bg-primary/30">
    <load src="/src/partials/sidebar.html" active="$($PageInfo.Active)" />
    <main class="flex-1 flex flex-col relative min-w-0">
      <load
        src="/src/partials/header.html"
        title="$($PageInfo.HeaderTitle)"
        subtitle="$($PageInfo.HeaderSubtitle)"
        icon="$($PageInfo.HeaderIcon)"
      />
$mainContent
"@
    
    # Save the new content
    Set-Content -Path $pageFile -Value $newContent -NoNewline -Encoding UTF8
    
    Write-Host "    SUCCESS: Fully refactored with partials" -ForegroundColor Green
    Write-Host ""
}

# Process each page
foreach ($page in $pages) {
    Refactor-SplitBillPage -PageInfo $page
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Complete Refactoring Done!" -ForegroundColor Green
Write-Host "============================================`n" -ForegroundColor Cyan

Write-Host "Summary:" -ForegroundColor White
Write-Host "  - Replaced head with <load src='/src/partials/head.html' />"
Write-Host "  - Replaced sidebar with <load src='/src/partials/sidebar.html' active='split-bill' />"
Write-Host "  - Replaced header with <load src='/src/partials/header.html' .../>"
Write-Host "  - Preserved unique page styles and content`n"

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Test all pages in browser"
Write-Host "  2. git diff to review changes"
Write-Host "  3. git add . && git commit -m 'refactor: complete partial implementation for split bill pages'"
Write-Host "  4. Remove .backup files`n"
