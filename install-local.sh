#!/bin/bash
# Local installation script for kdebug
# This installs kdebug to /usr/local/bin for immediate use

set -e

echo "🚀 Installing kdebug locally..."

# Check if bin/kdebug exists
if [ ! -f "bin/kdebug" ]; then
    echo "❌ Error: bin/kdebug not found"
    exit 1
fi

# Make sure it's executable
chmod +x bin/kdebug

# Create symlink in /usr/local/bin
if [ -L "/usr/local/bin/kdebug" ]; then
    echo "⚠️  Removing existing kdebug symlink..."
    sudo rm /usr/local/bin/kdebug
fi

echo "📦 Creating symlink in /usr/local/bin..."
sudo ln -s "$(pwd)/bin/kdebug" /usr/local/bin/kdebug

echo "✅ kdebug installed successfully!"
echo ""
echo "You can now run: kdebug --help"
echo ""
echo "To uninstall, run: sudo rm /usr/local/bin/kdebug"

# Made with Bob
