#!/bin/bash
# ================================================
# Script tích hợp Cursor Memory Bank + Flutter Cursor Plugin
# + Copy file flutter_build.md vào build.mdc
# ================================================

set -e

echo "🚀 Bắt đầu tích hợp Cursor Memory Bank + Flutter Cursor Plugin..."

PROJECT_DIR="$(pwd)"
PLUGIN_LOCAL_PATH="$HOME/.cursor/plugins/local/flutter-cursor-plugin"
MEMORY_BANK_REPO="https://github.com/vanzan01/cursor-memory-bank.git"
PLUGIN_REPO="https://github.com/Wreos/flutter-cursor-plugin.git"

# ===================== CONFIG =====================
# Đường dẫn đến file flutter_build.md của bạn
FLUTTER_BUILD_MD_PATH="./flutter_build.md"     # ← Bạn có thể thay đổi đường dẫn này

echo "📍 Project hiện tại: $PROJECT_DIR"

# ===================== 1. Kiểm tra file flutter_build.md =====================
if [ ! -f "$FLUTTER_BUILD_MD_PATH" ]; then
  echo "❌ Không tìm thấy file flutter_build.md tại: $FLUTTER_BUILD_MD_PATH"
  echo "Vui lòng kiểm tra lại đường dẫn hoặc đặt file flutter_build.md vào thư mục gốc project."
  exit 1
fi

echo "✅ Đã tìm thấy file flutter_build.md"

# ===================== 2. Tích hợp flutter-cursor-plugin =====================
echo "🔌 Đang cài đặt và copy flutter-cursor-plugin..."

if [ ! -d "$PLUGIN_LOCAL_PATH" ]; then
  echo "📥 Clone flutter-cursor-plugin..."
  mkdir -p "$HOME/.cursor/plugins/local"
  git clone "$PLUGIN_REPO" "$PLUGIN_LOCAL_PATH"
else
  echo "✅ Plugin đã tồn tại"
fi

# Copy files từ plugin
mkdir -p .cursor
cp -r "$PLUGIN_LOCAL_PATH/rules/" .cursor/ 2>/dev/null || true
cp -r "$PLUGIN_LOCAL_PATH/commands/" .cursor/ 2>/dev/null || true
cp -r "$PLUGIN_LOCAL_PATH/skills/" .cursor/ 2>/dev/null || true

cp "$PLUGIN_LOCAL_PATH/mcp.json" .cursor/mcp.json 2>/dev/null || true

echo "✅ Đã copy files từ flutter-cursor-plugin"

# ===================== 3. Tạo mcp.json cho FVM =====================
cat > .cursor/mcp.json << EOF
{
  "mcpServers": {
    "dart": {
      "command": "fvm",
      "args": ["dart", "mcp-server", "--force-roots-fallback"]
    },
    "flutter": {
      "command": "fvm",
      "args": ["flutter", "mcp-server", "--force-roots-fallback"]
    }
  }
}
EOF

# ===================== 4. Tích hợp Cursor Memory Bank =====================
echo "🧠 Tích hợp Cursor Memory Bank..."
git clone "$MEMORY_BANK_REPO" temp-memory

cp -r temp-memory/.cursor/* .cursor/ 2>/dev/null || true

mkdir -p memory-bank
cp -r temp-memory/memory-bank/* memory-bank/ 2>/dev/null || true

rm -rf temp-memory
echo "✅ Đã tích hợp Memory Bank"

# ===================== 5. Copy flutter_build.md vào build.mdc =====================
echo "📄 Đang copy nội dung flutter_build.md vào .cursor/commands/build.mdc ..."

mkdir -p .cursor/commands

# Copy và đổi tên thành build.mdc
cp "$FLUTTER_BUILD_MD_PATH" .cursor/commands/build.mdc

echo "✅ Đã thay thế nội dung .cursor/commands/build.mdc từ file flutter_build.md"

# ===================== 6. Hoàn tất =====================
echo ""
echo "========================================"
echo "🎉 HOÀN TẤT TÍCH HỢP TOÀN BỘ!"
echo "========================================"
echo ""
echo "Đã thực hiện:"
echo "   • Cài flutter-cursor-plugin"
echo "   • Tích hợp Cursor Memory Bank"
echo "   • Copy nội dung flutter_build.md vào build.mdc"
echo "   • Tạo mcp.json cho FVM"
echo ""
echo "Các bước tiếp theo:"
echo "1. Restart Cursor hoàn toàn"
echo "2. Mở project trong Cursor"
echo "3. Chạy: setup-flutter-environment"
echo "4. Chạy: list available flutter commands"
echo "5. Chạy: /van"
echo ""
echo "Chúc bạn phát triển hiệu quả! 💪"