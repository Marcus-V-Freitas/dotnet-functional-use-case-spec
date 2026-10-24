#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-all}"
SCOPE="${2:-project}"
PROJECT_PATH="${3:-$(pwd)}"
SKILL="${4:-all}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Discover available skills in the script directory (directories containing SKILL.md)
SKILLS=()
if [[ "$SKILL" != "all" ]]; then
  if [[ ! -f "$SCRIPT_DIR/$SKILL/SKILL.md" ]]; then
    echo "Error: Skill '$SKILL' not found in '$SCRIPT_DIR'." >&2
    echo "Available skills:" >&2
    for dir in "$SCRIPT_DIR"/*/; do
      if [[ -f "${dir}SKILL.md" ]]; then
        echo "  - $(basename "$dir")" >&2
      fi
    done
    exit 1
  fi
  SKILLS=("$SKILL")
else
  for dir in "$SCRIPT_DIR"/*/; do
    if [[ -f "${dir}SKILL.md" ]]; then
      SKILLS+=("$(basename "$dir")")
    fi
  done
fi

install_skills_to_dir() {
  local dest_root="$1"
  mkdir -p "$dest_root"
  for s in "${SKILLS[@]}"; do
    local src="$SCRIPT_DIR/$s"
    local dest="$dest_root/$s"
    rm -rf "$dest"
    cp -R "$src" "$dest"
    echo "  -> Installed [$s] to $dest"
  done
}

install_target() {
  local name="$1"
  echo "Installing to target: $name (scope: $SCOPE)..."
  if [[ "$SCOPE" == "project" ]]; then
    case "$name" in
      github)      install_skills_to_dir "$PROJECT_PATH/.github/skills" ;;
      claude)      install_skills_to_dir "$PROJECT_PATH/.claude/skills" ;;
      gemini)      install_skills_to_dir "$PROJECT_PATH/.gemini/skills" ;;
      antigravity) install_skills_to_dir "$PROJECT_PATH/.agents/skills" ;;
      *) echo "Unknown target: $name" >&2; exit 1 ;;
    esac
  else
    case "$name" in
      github)      install_skills_to_dir "$HOME/.copilot/skills" ;;
      claude)      install_skills_to_dir "$HOME/.claude/skills" ;;
      gemini)      install_skills_to_dir "$HOME/.gemini/skills" ;;
      antigravity)
        install_skills_to_dir "$HOME/.gemini/antigravity/skills"
        install_skills_to_dir "$HOME/.gemini/config/skills"
        ;;
      *) echo "Unknown target: $name" >&2; exit 1 ;;
    esac
  fi
}

if [[ "$TARGET" == "all" ]]; then
  for t in github claude gemini antigravity; do
    install_target "$t"
  done
else
  install_target "$TARGET"
fi

echo "Done! (${#SKILLS[@]} skill(s) installed for target: $TARGET)"
