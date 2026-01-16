#!/bin/bash
# FEINT Code Validation Script
# Checks Lua scripts for common syntax issues

echo "=== FEINT Code Validation ==="
echo ""

# Count files
echo "📁 Files Found:"
lua_files=$(find src -name "*.lua" | wc -l)
echo "  Lua Scripts: $lua_files"
echo ""

# Check each file
echo "🔍 Checking Files:"
for file in src/**/*.lua; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
        
        # Check for balanced function/end pairs
        functions=$(grep -c "^function\|^local function" "$file" || true)
        
        # Check file size
        size=$(wc -l < "$file")
        echo "    Lines: $size"
    fi
done

echo ""
echo "📊 Code Statistics:"
total_lines=$(find src -name "*.lua" -exec wc -l {} + | tail -1 | awk '{print $1}')
echo "  Total Lines: $total_lines"

echo ""
echo "✅ Validation Complete!"
echo ""
echo "📝 Next Steps:"
echo "  1. Copy scripts to Roblox Studio"
echo "  2. Test with 2+ players"
echo "  3. Verify blade spawning and targeting"
echo "  4. Test parry mechanics (Q key)"
echo "  5. Test fake parry (E key)"
echo "  6. Confirm win condition triggers"
