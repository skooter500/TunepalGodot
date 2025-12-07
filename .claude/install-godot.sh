#!/bin/bash
# SessionStart hook to install Godot 4.3 for testing
# This runs automatically when Claude Code starts a session in this repo

set -e

GODOT_VERSION="4.3-stable"
GODOT_DIR="$HOME/.local/godot"
GODOT_BIN="$GODOT_DIR/godot"

echo "=== Godot 4.3 Setup ==="

# Check if already installed
if [ -x "$GODOT_BIN" ]; then
    echo "Godot already installed at $GODOT_BIN"
    "$GODOT_BIN" --version 2>/dev/null || true

    # Add to PATH for this session
    if [ -n "$CLAUDE_ENV_FILE" ]; then
        echo "export PATH=\"\$PATH:$GODOT_DIR\"" >> "$CLAUDE_ENV_FILE"
    fi
    exit 0
fi

echo "Installing Godot $GODOT_VERSION..."

# Create directory
mkdir -p "$GODOT_DIR"
cd "$GODOT_DIR"

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    GODOT_ARCH="x86_64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    GODOT_ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Detect OS and download appropriate version
OS=$(uname -s)
if [ "$OS" = "Linux" ]; then
    GODOT_URL="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_linux.${GODOT_ARCH}.zip"
    GODOT_EXTRACTED="Godot_v${GODOT_VERSION}_linux.${GODOT_ARCH}"
elif [ "$OS" = "Darwin" ]; then
    GODOT_URL="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_macos.universal.zip"
    GODOT_EXTRACTED="Godot.app/Contents/MacOS/Godot"
else
    echo "Unsupported OS: $OS"
    exit 1
fi

# Download and extract
echo "Downloading from $GODOT_URL..."
if command -v curl &> /dev/null; then
    curl -L -o godot.zip "$GODOT_URL"
elif command -v wget &> /dev/null; then
    wget -q -O godot.zip "$GODOT_URL"
else
    echo "Neither curl nor wget available"
    exit 1
fi

echo "Extracting..."
unzip -q -o godot.zip
rm godot.zip

# Create symlink
if [ "$OS" = "Darwin" ]; then
    ln -sf "$GODOT_DIR/$GODOT_EXTRACTED" "$GODOT_BIN"
else
    chmod +x "$GODOT_EXTRACTED"
    ln -sf "$GODOT_DIR/$GODOT_EXTRACTED" "$GODOT_BIN"
fi

# Add to PATH for this session
if [ -n "$CLAUDE_ENV_FILE" ]; then
    echo "export PATH=\"\$PATH:$GODOT_DIR\"" >> "$CLAUDE_ENV_FILE"
fi

echo "Godot installed successfully!"
"$GODOT_BIN" --version 2>/dev/null || true
exit 0
