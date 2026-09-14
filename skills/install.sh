#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-all}"
SCOPE="${2:-project}"
PROJECT_PATH="${3:-$(pwd)}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/dotnet-functional-use-case-spec"

install_skill() {
  local root="$1"
  local dest="$root/dotnet-functional-use-case-spec"
  mkdir -p "$root"
  rm -rf "$dest"
  cp -R "$SOURCE" "$dest"
  echo "Installed: $dest"
}

install_target() {
  local name="$1"
  if [[ "$SCOPE" == "project" ]]; then
    case "$name" in
      github) install_skill "$PROJECT_PATH/.github/skills" ;;
      claude) install_skill "$PROJECT_PATH/.claude/skills" ;;
      gemini) install_skill "$PROJECT_PATH/.gemini/skills" ;;
      antigravity) install_skill "$PROJECT_PATH/.agents/skills" ;;
    esac
  else
    case "$name" in
      github) install_skill "$HOME/.copilot/skills" ;;
      claude) install_skill "$HOME/.claude/skills" ;;
      gemini) install_skill "$HOME/.gemini/skills" ;;
      antigravity) install_skill "$HOME/.gemini/antigravity/skills" ;;
    esac
  fi
}

if [[ "$TARGET" == "all" ]]; then
  for t in github claude gemini antigravity; do install_target "$t"; done
else
  install_target "$TARGET"
fi
