#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Create workspace if it doesn't exist
mkdir -p workspace

# If a project path is provided, copy it
if [ -n "$1" ]; then
    PROJECT_PATH="$1"
    if [ -d "$PROJECT_PATH" ]; then
        echo "Copying project from $PROJECT_PATH to workspace..."
        rm -rf workspace/*
        cp -r "$PROJECT_PATH"/* workspace/ 2>/dev/null || true
        cp -r "$PROJECT_PATH"/.[!.]* workspace/ 2>/dev/null || true
    else
        echo "Error: $PROJECT_PATH is not a directory"
        exit 1
    fi
fi

# Build the image
echo "Building Docker image..."
docker build -t claude-sandbox .

echo ""
echo "Starting Claude sandbox..."
echo "Network: Only Anthropic endpoints allowed"
echo "Files: Only ./workspace is accessible"
echo ""

# Run the sandbox
docker run -it --rm \
    --cap-add=NET_ADMIN \
    -v "$SCRIPT_DIR/workspace:/project" \
    claude-sandbox \
    bash -c "init-firewall.sh && claude --dangerously-skip-permissions"
