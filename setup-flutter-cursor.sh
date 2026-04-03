#!/bin/bash

# ================================================
# Setup Flutter + Cursor Memory Bank + Flutter Cursor Plugin
# Tên project: my-flutter-app (bạn có thể thay đổi)
# ================================================

set -e  # Dừng script nếu có lỗi

# ===================== CẤU HÌNH =====================
PROJECT_NAME="cursor_base_flutter"
MEMORY_BANK_REPO="https://github.com/vanzan01/cursor-memory-bank.git"
PLUGIN_EXAMPLE_REPO="https://github.com/Wreos/flutter-cursor-plugin-example.git"

echo "🚀 Bắt đầu thiết lập project Flutter với Cursor Memory Bank + Flutter Cursor Plugin..."

# 1. Clone project base từ flutter-cursor-plugin-example
if [ -d "$PROJECT_NAME" ]; then
  echo "⚠️  Thư mục $PROJECT_NAME đã tồn tại. Đang xóa để tạo mới..."
  rm -rf "$PROJECT_NAME"
fi

echo "📥 Cloning Flutter project example..."
git clone "$PLUGIN_EXAMPLE_REPO" "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 1.1 su dung fem

fvm use 3.41.6

# 2. Cài dependencies
echo "📦 Chạy flutter pub get..."
fvm flutter pub get

# 3. Kiểm tra cơ bản
echo "🔍 Kiểm tra project..."
fvm flutter analyze
fvm flutter test

# 4. Tích hợp Cursor Memory Bank
echo "🔗 Tích hợp Cursor Memory Bank..."
git clone "$MEMORY_BANK_REPO" temp-memory

# Copy .cursor folder (chứa rules và commands)
cp -r temp-memory/.cursor ./

# Copy memory-bank folder (nếu muốn có mẫu sẵn)
mkdir -p memory-bank
cp -r temp-memory/memory-bank/* memory-bank/ 2>/dev/null || true

# Xóa thư mục tạm
rm -rf temp-memory

echo "✅ Đã tích hợp Memory Bank thành công!"

# 5. Thông báo các bước tiếp theo
echo ""
echo "========================================"
echo "🎉 HOÀN TẤT THIẾT LẬP!"
echo "========================================"
echo ""
echo "Project đã được tạo tại thư mục: $(pwd)"
echo ""
echo "Các bước tiếp theo bạn cần làm thủ công trong Cursor:"
echo "1. Mở project này bằng Cursor Editor"
echo "2. Cài đặt flutter-cursor-plugin (local):"
echo "   - Clone plugin: git clone https://github.com/Wreos/flutter-cursor-plugin.git"
echo "   - Copy vào: ~/.cursor/plugins/local/flutter-cursor-plugin/"
echo "3. Khởi động lại Cursor"
echo "4. Trong Cursor, gõ lệnh: /van   ← để khởi tạo Memory Bank"
echo "5. Sau đó chạy: setup-flutter-environment   ← (lệnh của plugin)"
echo ""
echo "Khi đã xong, bạn có thể dùng:"
echo "   /plan → /build → /reflect"
echo ""
echo "Chúc bạn phát triển hiệu quả! 💪"

