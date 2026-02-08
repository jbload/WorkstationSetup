#!/bin/zsh
ghostty_path="$HOME/Library/Application Support/com.mitchellh.ghostty/config"

echo "📦 Backing up $ghostty_path..."
cp "$ghostty_path" "$ghostty_path-$(date +%F_%R).backup"

echo "💾 Copying ghostty.conf to $ghostty_path..."
cp ghostty.conf "$ghostty_path"

echo "✅ Done!"
