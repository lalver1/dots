if brew list coreutils >/dev/null 2>&1; then
    echo "   [SKIP] coreutils is already installed."
else
    echo "   [INSTALL] Installing coreutils..."
    brew install coreutils
fi
