#!/bin/bash
# ================================================
# Script tích hợp Cursor Memory Bank + Flutter Cursor Plugin
# Chỉ copy 4 rule quan trọng + copy flutter_build.md vào build.mdc
# ================================================

set -e

echo "🚀 Bắt đầu tích hợp Cursor Memory Bank + Flutter Cursor Plugin..."

PROJECT_DIR="$(pwd)"
PLUGIN_LOCAL_PATH="$HOME/.cursor/plugins/local/flutter-cursor-plugin"
MEMORY_BANK_REPO="https://github.com/vanzan01/cursor-memory-bank.git"
PLUGIN_REPO="https://github.com/Wreos/flutter-cursor-plugin.git"

# ===================== CONFIG =====================
FLUTTER_BUILD_MD_PATH="./flutter_build.md"     # Đường dẫn đến file flutter_build.md của bạn

echo "📍 Project hiện tại: $PROJECT_DIR"

# ===================== 1. Kiểm tra file flutter_build.md =====================
if [ ! -f "$FLUTTER_BUILD_MD_PATH" ]; then
  echo "❌ Không tìm thấy file flutter_build.md tại: $FLUTTER_BUILD_MD_PATH"
  echo "Vui lòng đặt file flutter_build.md vào thư mục gốc project hoặc chỉnh sửa đường dẫn."
  exit 1
fi

echo "✅ Đã tìm thấy file flutter_build.md"

# ===================== 2. Tích hợp flutter-cursor-plugin =====================
echo "🔌 Đang cài đặt flutter-cursor-plugin..."

if [ ! -d "$PLUGIN_LOCAL_PATH" ]; then
  echo "📥 Clone flutter-cursor-plugin..."
  mkdir -p "$HOME/.cursor/plugins/local"
  git clone "$PLUGIN_REPO" "$PLUGIN_LOCAL_PATH"
else
  echo "✅ Plugin đã tồn tại tại $PLUGIN_LOCAL_PATH"
fi

# ===================== 3. Copy chỉ 4 rule quan trọng =====================
echo "📋 Copy 4 rule quan trọng từ plugin vào .cursor/rules/..."

mkdir -p .cursor/rules

cp "$PLUGIN_LOCAL_PATH/rules/dart-effective-dart.mdc" .cursor/rules/ 2>/dev/null || true
cp "$PLUGIN_LOCAL_PATH/rules/flutter-development-best-practices.mdc" .cursor/rules/ 2>/dev/null || true
cp "$PLUGIN_LOCAL_PATH/rules/flutter-plugin-policy-priority.mdc" .cursor/rules/ 2>/dev/null || true
cp "$PLUGIN_LOCAL_PATH/rules/flutter-test-best-practices.mdc" .cursor/rules/ 2>/dev/null || true

echo "✅ Đã copy 4 rule quan trọng: dart-effective-dart, flutter-development-best-practices, flutter-plugin-policy-priority, flutter-test-best-practices"

# ===================== 4. Tạo mcp.json cho FVM =====================
echo "⚙️ Tạo file .cursor/mcp.json..."

mkdir -p .cursor

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

echo "✅ Đã tạo .cursor/mcp.json"

# ===================== 5. Tích hợp Cursor Memory Bank =====================
echo "🧠 Tích hợp Cursor Memory Bank..."

git clone "$MEMORY_BANK_REPO" temp-memory

cp -r temp-memory/.cursor/* .cursor/ 2>/dev/null || true

mkdir -p memory-bank
cp -r temp-memory/memory-bank/* memory-bank/ 2>/dev/null || true

rm -rf temp-memory
echo "✅ Đã tích hợp Cursor Memory Bank"

# ===================== 6. Copy flutter_build.md vào build.mdc =====================
echo "📄 Copy nội dung flutter_build.md vào .cursor/commands/build.md ..."

mkdir -p .cursor/commands

# Xóa file build.mdc cũ nếu tồn tại để tránh lỗi ghi đè
if [ -f ".cursor/commands/build.md" ]; then
  echo "🗑️  Đang xóa file build.md cũ..."
  rm -f ".cursor/commands/build.md"
fi

cp "$FLUTTER_BUILD_MD_PATH" .cursor/commands/build.md

echo "✅ Đã thay thế file .cursor/commands/build.md"

# ===================== 7. Hoàn tất =====================
echo ""
echo "========================================"
echo "🎉 HOÀN TẤT TÍCH HỢP!"
echo "========================================"
echo ""
echo "Đã thực hiện:"
echo "   • Cài flutter-cursor-plugin"
echo "   • Copy 4 rule quan trọng"
echo "   • Tích hợp Cursor Memory Bank"
echo "   • Copy flutter_build.md → build.mdc"
echo "   • Tạo mcp.json cho FVM"
echo ""
echo "Các bước tiếp theo:"
echo "1. Restart Cursor hoàn toàn"
echo "2. Chạy: setup-flutter-environment"
echo "3. Chạy: list available flutter commands"
echo "4. Chạy: /van"
echo ""
echo "Chúc bạn phát triển hiệu quả! 💪"
