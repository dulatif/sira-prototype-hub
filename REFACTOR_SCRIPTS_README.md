# Split Bill Pages Refactoring Scripts

This directory contains automation scripts to refactor the split bill utility pages (`sira_split_bill_utility_1` through `_5`) to use modular partial HTML components.

## 📋 What These Scripts Do

The scripts will:

1. ✅ Replace hardcoded `<head>` sections with `<load src="/src/partials/head.html" ... />`
2. ✅ Preserve unique page-specific styles (glass effects, gradients, scrollbars)
3. ✅ Keep all body content unchanged
4. ✅ Create `.backup` files before modifying originals

## 🚀 Usage

### Option 1: PowerShell (Recommended for Windows)

```powershell
./refactor_split_bill.ps1
```

### Option 2: Bash (Git Bash on Windows or Linux/Mac)

```bash
./refactor_split_bill.sh
```

### Option 3: Windows Batch

```cmd
refactor_split_bill.bat
```

## 📝 After Running the Script

1. **Review changes:**

   ```bash
   git diff
   ```

2. **Test in browser:**

   - Navigate to each split bill page
   - Verify styles and icons load correctly
   - Check that all functionality works

3. **Commit if satisfied:**

   ```bash
   git add .
   git commit -m "refactor: implement partial components in split bill pages"
   ```

4. **Remove backups (optional):**

   ```bash
   # PowerShell
   Remove-Item **/*.backup

   # Bash
   find . -name "*.backup" -delete
   ```

## 🎯 Pages Affected

- `sira_split_bill_utility_1/code.html`
- `sira_split_bill_utility_2/code.html` (Data Importer)
- `sira_split_bill_utility_3/code.html` (Matrix view)
- `sira_split_bill_utility_4/code.html`
- `sira_split_bill_utility_5/code.html`

## ⚠️ Notes

- **Backups:** The scripts automatically create `.backup` files. Keep these until you've verified the refactoring works.
- **Encoding:** All scripts preserve UTF-8 encoding.
- **Line Endings:** Git will handle CRLF/LF conversion automatically.

## 🔍 Troubleshooting

If you encounter issues:

1. **Restore from backup:**

   ```bash
   # PowerShell
   Get-ChildItem -Recurse -Filter "*.backup" | ForEach-Object {
       $original = $_.FullName -replace '\.backup$', ''
       Copy-Item $_.FullName $original -Force
   }

   # Bash
   find . -name "*.backup" -exec sh -c 'cp "$1" "${1%.backup}"' _ {} \;
   ```

2. **Manual verification:** Check that `</head>` tag exists in each file before running.

## ✅ Already Completed

The following pages have already been refactored manually:

- ✅ `sira_user_settings_profile/code.html`
- ✅ `sira_category_manager_split_pane_2/code.html`
- ✅ `sira_category_manager_split_pane_3/code.html`
- ✅ `sira_wealth_flow_dashboard_3/code.html`
- ✅ `sira_wealth_flow_dashboard_4/code.html`
- ✅ `sira_wealth_flow_dashboard_5/code.html`
