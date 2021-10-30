#!/usr/bin/env bash
# shellcheck disable=SC2001,SC2059
set -E -e -o pipefail -u

Debugln () { echo "$*" | awk "{print \"\\033[0;34m$(date +%Y-%m-%dT%H:%M:%S%z) [DEBUG] \"\$0\"\\033[0m\"}"; }
Infoln  () { echo "$*" | awk "{print \"\\033[0;32m$(date +%Y-%m-%dT%H:%M:%S%z) [ INFO] \"\$0\"\\033[0m\"}"; }
Warnln  () { echo "$*" | awk "{print \"\\033[0;33m$(date +%Y-%m-%dT%H:%M:%S%z) [ WARN] \"\$0\"\\033[0m\"}"; }
Errorln () { echo "$*" | awk "{print \"\\033[0;31m$(date +%Y-%m-%dT%H:%M:%S%z) [ERROR] \"\$0\"\\033[0m\"}"; }

Debugln '$' "$0 $*"

if [[ $# -le 0 ]]; then
  Errorln "Specify the path to the gitignore file."
  exit 1
fi

# shellcheck disable=SC2207
declare -a UNIQ=( $( printf "%s\n" "$@" | sort -u ) )

# shellcheck disable=SC2016
Infoln 'Check that no files that should `gitignore` are committed.'
Infoln ".gitignore files: ${UNIQ[*]}"

for GITIGNORE in "${UNIQ[@]}"; do
  Infoln "Check ${GITIGNORE:?}"
  if [[ ! -f "${GITIGNORE:?}" ]]; then
    Warnln "${GITIGNORE:?}: no such file or directory. skip."
    continue
  fi

  Debugln '$' git ls-files --cached --ignored --exclude-from="${GITIGNORE:?}"
  output=$(git ls-files --cached --ignored --exclude-from="${GITIGNORE:?}")
  printf "${output-}${output:+$'\n'}"

  # If there is any content in `output`,
  if [[ "${output-}" ]]; then
    # add it to `all`.
    all="${all-}${all:+$'\n'}${output:?}"
  fi
done

if [[ "${all-}" ]]; then
  Errorln "Found files that should gitignore are committed:"
  all_formatted="$(echo "${all:?}" | sort -u | sed "s/^/  - /")"
  Errorln "${all_formatted:?}"
  exit 1
fi

Infoln "No problems found."
