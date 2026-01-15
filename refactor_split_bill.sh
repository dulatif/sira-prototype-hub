#!/bin/bash

# Refactor Split Bill Utility Pages to Use Partial Components
# This script replaces hardcoded <head> sections with <load> tags

set -e

echo "🔧 Starting Split Bill Pages Refactoring..."

# Array of split bill utility pages to refactor
pages=(
  "sira_split_bill_utility_1"
  "sira_split_bill_utility_2"
  "sira_split_bill_utility_3"
  "sira_split_bill_utility_4"
  "sira_split_bill_utility_5"
)

# Function to refactor a single page
refactor_page() {
  local page_dir=$1
  local page_file="${page_dir}/code.html"
  
  echo "  📄 Processing: $page_file"
  
  # Check if file exists
  if [ ! -f "$page_file" ]; then
    echo "    ❌ File not found: $page_file"
    return 1
  fi
  
  # Create backup
  cp "$page_file" "${page_file}.backup"
  
  # Determine the title based on page name
  local title="Sira - Split Bill"
  if [[ "$page_dir" == *"utility_2"* ]]; then
    title="Sira - Data Importer Center"
  fi
  
  # Create temporary file for the refactored content
  local temp_file="${page_file}.tmp"
  
  # Start writing the new file
  cat > "$temp_file" << 'HEADER_START'
<!DOCTYPE html>
<html class="light" lang="en">
  <head>
HEADER_START
  
  # Add the load tag for head partial
  echo "    <load src=\"/src/partials/head.html\" title=\"${title}\" />" >> "$temp_file"
  
  # Add unique styles for this page
  cat >> "$temp_file" << 'STYLES_START'
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
STYLES_START

  # Add matrix checkbox styles for utility_3
  if [[ "$page_dir" == *"utility_3"* ]]; then
    cat >> "$temp_file" << 'MATRIX_STYLES'
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
MATRIX_STYLES
  fi
  
  # Close style tag and head
  cat >> "$temp_file" << 'STYLES_END'
    </style>
  </head>
STYLES_END
  
  # Extract body content (everything after </head>)
  # Find the line number where </head> appears in the original file
  local head_end_line=$(grep -n "</head>" "$page_file" | head -1 | cut -d: -f1)
  
  if [ -z "$head_end_line" ]; then
    echo "    ❌ Could not find </head> tag in $page_file"
    rm "$temp_file"
    return 1
  fi
  
  # Append everything after </head> from the original file
  tail -n +$((head_end_line + 1)) "$page_file" >> "$temp_file"
  
  # Replace original file with refactored version
  mv "$temp_file" "$page_file"
  
  echo "    ✅ Refactored successfully"
}

# Main execution
echo ""
for page in "${pages[@]}"; do
  refactor_page "$page"
done

echo ""
echo "✨ Refactoring complete!"
echo ""
echo "📋 Summary:"
echo "  - Replaced hardcoded <head> sections with <load> tags"
echo "  - Preserved unique styles for each page"
echo "  - Created backups with .backup extension"
echo ""
echo "🔍 Next steps:"
echo "  1. Review the changes: git diff"
echo "  2. Test the pages in the browser"
echo "  3. If satisfied, commit: git add . && git commit -m 'refactor: implement partials in split bill pages'"
echo "  4. Remove backups: rm **/code.html.backup"
echo ""
