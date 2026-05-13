#!/usr/bin/env bash
# rename_files.sh — Rename files in a directory by replacing a pattern
#
# Usage:
#   ./rename_files.sh [OPTIONS] <search> <replace> [directory]
#
# Arguments:
#   <search>      Pattern to find in filenames (plain text or regex with -r)
#   <replace>     Replacement string
#   [directory]   Target directory (default: current directory)
#
# Options:
#   -r            Treat <search> as an extended regex (ERE)
#   -e            File extension filter, e.g. -e txt (only rename .txt files)
#   -n            Dry run — show what would be renamed, without doing it
#   -R            Recurse into subdirectories
#   -h            Show this help message
#
# Examples:
#   ./rename_files.sh test sample               # abc-test.txt => abc-sample.txt
#   ./rename_files.sh -n test sample ./docs     # dry run in ./docs
#   ./rename_files.sh -r '^abc' 'xyz' .         # regex: rename files starting with abc
#   ./rename_files.sh -e txt test sample .      # only .txt files
#   ./rename_files.sh -R test sample ./project  # recurse into subdirectories

set -euo pipefail

# ── Defaults ────────────────────────────────────────────────────────────────
USE_REGEX=false
DRY_RUN=false
RECURSE=false
EXT_FILTER=""

# ── Colours ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; RESET='\033[0m'; BOLD='\033[1m'

usage() {
  sed -n '/^# Usage:/,/^$/{ s/^# \?//; p }' "$0"
  exit 0
}

err()  { echo -e "${RED}Error:${RESET} $*" >&2; exit 1; }
info() { echo -e "${CYAN}$*${RESET}"; }
ok()   { echo -e "${GREEN}✔${RESET}  $*"; }
skip() { echo -e "${YELLOW}–${RESET}  $*"; }

# ── Option parsing ───────────────────────────────────────────────────────────
while getopts ":rne:Rh" opt; do
  case $opt in
    r) USE_REGEX=true ;;
    n) DRY_RUN=true ;;
    e) EXT_FILTER="$OPTARG" ;;
    R) RECURSE=true ;;
    h) usage ;;
    :) err "Option -$OPTARG requires an argument." ;;
    \?) err "Unknown option: -$OPTARG" ;;
  esac
done
shift $((OPTIND - 1))

[[ $# -lt 2 ]] && { echo "Usage: $0 [OPTIONS] <search> <replace> [directory]"; exit 1; }

SEARCH="$1"
REPLACE="$2"
TARGET_DIR="${3:-.}"

[[ -d "$TARGET_DIR" ]] || err "Directory not found: $TARGET_DIR"

# ── Rename logic ─────────────────────────────────────────────────────────────
do_rename() {
  local filepath="$1"
  local dir file newfile newpath

  dir="$(dirname "$filepath")"
  file="$(basename "$filepath")"

  # Apply extension filter
  if [[ -n "$EXT_FILTER" ]] && [[ "$file" != *."$EXT_FILTER" ]]; then
    return 0
  fi

  # Compute new filename
  if $USE_REGEX; then
    newfile="$(echo "$file" | sed -E "s/${SEARCH}/${REPLACE}/g")"
  else
    newfile="${file//"$SEARCH"/$REPLACE}"
  fi

  [[ "$file" == "$newfile" ]] && return 0   # nothing changed

  newpath="$dir/$newfile"

  if [[ -e "$newpath" ]]; then
    skip "SKIP  $filepath  →  $newpath  (target already exists)"
    return 0
  fi

  if $DRY_RUN; then
    echo -e "  ${YELLOW}[dry-run]${RESET}  $filepath  ${BOLD}→${RESET}  $newpath"
  else
    mv -- "$filepath" "$newpath"
    ok "$filepath  →  $newpath"
  fi

  ((RENAMED++)) || true
}

# ── Main ─────────────────────────────────────────────────────────────────────
RENAMED=0

$DRY_RUN && info "Dry-run mode — no files will be renamed.\n"

if $RECURSE; then
  while IFS= read -r -d '' f; do
    [[ -f "$f" ]] && do_rename "$f"
  done < <(find "$TARGET_DIR" -mindepth 1 -type f -print0 | sort -z)
else
  while IFS= read -r -d '' f; do
    [[ -f "$f" ]] && do_rename "$f"
  done < <(find "$TARGET_DIR" -maxdepth 1 -type f -print0 | sort -z)
fi

echo ""
if $DRY_RUN; then
  info "$RENAMED file(s) would be renamed."
else
  info "$RENAMED file(s) renamed."
fi