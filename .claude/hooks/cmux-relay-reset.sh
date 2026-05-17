#!/usr/bin/env bash
# cmux-relay-reset.sh — UserPromptSubmit hook. Sibling of cmux-relay-topology.sh.
# Zeroes the cmux-relay shared round-trip counter on a human turn (invokes
# `cmux-relay.sh reset`). Replaces the manual judgment step that previously
# required the receiving session to detect a human turn and run `reset`.
#
# Hard constraints (mirror cmux-relay-topology.sh):
#   set -uo pipefail
#   every cmux / jq call guarded
#   ALWAYS exits 0 — blocking UserPromptSubmit erases the prompt and can loop
#                    the session, so every error path degrades to a silent
#                    `exit 0`.
#   NEVER emits `decision: "block"` — same reason.
#
# Six-step logic (design §2 Component A):
#   1. jq-parse stdin -> .prompt          (parse fail / no .prompt -> exit 0)
#   2. cmux_relay_resolve_root            (no .cmux-relay.json -> exit 0)
#   3. .prompt empty / whitespace-only    -> exit 0 (also absorbs bare-newline
#                                            double-fire — §4)
#   4. First-line-trimmed sentinel + live-nonce check:
#        line 1 ! ~ sentinel shape                    -> fall through
#        nonce IS a live marker (consume-marker rc 0) -> exit 0 (genuine relay)
#        nonce NOT a live marker (rc non-zero)        -> fall through (pasted /
#                                                        stale; NEW-02 guard)
#   5. Role check — fail toward reset (F-06 + NEW-01):
#        cmux clean + title IS a configured role  -> fall through (reset)
#        cmux clean + title NOT a configured role -> exit 0 (NEW-01: a non-
#                                                    relay same-worktree
#                                                    session must not zero
#                                                    prime/coach's counter)
#        cmux fails any way                       -> fall through (F-06: a
#                                                    cmux hiccup must never
#                                                    leave the counter stale)
#   6. bash cmux-relay.sh reset; swallow exit; exit 0
#
# See the relay-autoreset design (2026-05-14) §2/§3/§4.
set -uo pipefail

# --- locate + source the shared lib ------------------------------------------
# Prefer a sibling lib (dev tree / staged skill dir); fall back to the staged
# skill-library path (for a copied-into-.claude/hooks/ hook).
_crr_self_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd -P)"
_crr_lib=""
if [ -n "$_crr_self_dir" ] && [ -f "$_crr_self_dir/cmux-relay-lib.sh" ]; then
  _crr_lib="$_crr_self_dir/cmux-relay-lib.sh"
elif [ -f "$HOME/.claude/skill-library/cmux-relay/cmux-relay-lib.sh" ]; then
  _crr_lib="$HOME/.claude/skill-library/cmux-relay/cmux-relay-lib.sh"
fi
# Lib missing -> silent exit 0. We can't reset anything without it; don't block.
[ -z "$_crr_lib" ] && exit 0
# shellcheck source=/dev/null
. "$_crr_lib"

# --- 1. jq + stdin parse -----------------------------------------------------
# jq missing -> degrade to silent exit 0 (can't parse, can't safely reset).
_crr_jq="$(cmux_relay_resolve_jq)" || exit 0
# Read stdin once. `jq -r '.prompt // empty'`: malformed JSON -> jq stderr
# (suppressed) + empty stdout; missing .prompt -> empty; .prompt = "" -> empty.
_crr_stdin="$(cat 2>/dev/null || true)"
_crr_prompt="$(printf '%s' "$_crr_stdin" | "$_crr_jq" -r '.prompt // empty' 2>/dev/null)"
[ -z "$_crr_prompt" ] && exit 0

# --- 2. root resolution ------------------------------------------------------
cmux_relay_resolve_root || exit 0
_crr_config="$CMUX_RELAY_CONFIG_PATH"

# --- 3. empty / whitespace-only prompt ---------------------------------------
# jq -r '.prompt // empty' already returns empty for "" but a prompt that is
# only whitespace (spaces, tabs, newlines — including the bare-newline double-
# fire case in §4) survives jq. Strip all whitespace; if nothing remains, skip.
_crr_stripped="$(printf '%s' "$_crr_prompt" | tr -d '[:space:]')"
[ -z "$_crr_stripped" ] && exit 0

# --- 4. sentinel + live-nonce check ------------------------------------------
# Take the first line of the parsed .prompt; trim leading whitespace.
_crr_first_line="$(printf '%s' "$_crr_prompt" | sed -n '1p')"
# bash 3.2 POSIX trim: strip leading whitespace via parameter-expansion glob.
_crr_first_line="${_crr_first_line#"${_crr_first_line%%[![:space:]]*}"}"

# Sentinel shape (cmd_send line 341): `<!-- cmux-relay:relayed <nonce> -->`
# Whole-line case glob — anchored by construction (case matches the whole
# value, not a substring) which closes Codex F-07 (a mid-prompt sentinel must
# NOT suppress reset).
_crr_nonce=""
case "$_crr_first_line" in
  '<!-- cmux-relay:relayed '*' -->')
    _crr_nonce="${_crr_first_line#'<!-- cmux-relay:relayed '}"
    _crr_nonce="${_crr_nonce%' -->'}"
    ;;
esac

# Resolve cmux-relay.sh path once — needed for step 4's consume-marker AND
# step 6's reset. `resolve_relay_script` always echoes SOMETHING, so the
# `-f` guard is what gates real use.
_crr_relay_script="$(cmux_relay_resolve_relay_script "$_crr_config" "$_crr_jq" 2>/dev/null || true)"

if [ -n "$_crr_nonce" ]; then
  if [ -n "$_crr_relay_script" ] && [ -f "$_crr_relay_script" ]; then
    # rc 0 -> live marker, was consumed -> genuine relay -> no reset.
    # rc non-zero -> absent / pasted / stale -> fall through to reset
    # (closes Codex NEW-02 — a human pasting a relayed message verbatim has
    #  the sentinel as line 1 but no live marker, so the reset still fires).
    if bash "$_crr_relay_script" consume-marker "$_crr_nonce" >/dev/null 2>&1; then
      exit 0
    fi
  fi
  # script missing -> fall through (degrade — reset is the safe direction).
fi

# --- 5. role check (fail-toward-reset; F-06 + NEW-01) ------------------------
# Determine if reset should be SUPPRESSED because the caller is a non-relay
# session in the same worktree. Default 0 (do reset — F-06 fail-toward-reset).
_crr_suppress=0

# Wrap in a function so any guarded failure short-circuits without affecting
# the default. The function returns 0 in every outcome (suppress decision is
# carried via _crr_suppress); the wrapping `|| true` is defensive only.
_crr_role_check() {
  local cmux identify caller_ref tree my_title roles_tsv tab
  local my_title_lc role title title_lc
  cmux="$(cmux_relay_resolve_cmux 2>/dev/null)" || return 0
  identify="$("$cmux" identify 2>/dev/null)" || return 0
  caller_ref="$(printf '%s' "$identify" | "$_crr_jq" -r '.caller.surface_ref // empty' 2>/dev/null)"
  [ -z "$caller_ref" ] && return 0
  tree="$("$cmux" tree --json 2>/dev/null)" || return 0
  [ -z "$tree" ] && return 0
  my_title="$(printf '%s' "$tree" | "$_crr_jq" -r --arg ref "$caller_ref" '
    [ .windows[]?.workspaces[]?.panes[]?.surfaces[]? | select(.ref == $ref) | .title ]
    | .[0] // empty
  ' 2>/dev/null)"
  [ -z "$my_title" ] && return 0
  roles_tsv="$("$_crr_jq" -r '.roles | to_entries[] | "\(.key)\t\(.value)"' "$_crr_config" 2>/dev/null)"
  [ -z "$roles_tsv" ] && return 0
  tab="$(printf '\t')"
  my_title_lc="$(printf '%s' "$my_title" | tr '[:upper:]' '[:lower:]')"
  # Walk roles; any match -> caller IS a configured role -> do reset (default).
  while IFS="$tab" read -r role title; do
    [ -z "$role" ] && continue
    title_lc="$(printf '%s' "$title" | tr '[:upper:]' '[:lower:]')"
    if [ "$title_lc" = "$my_title_lc" ]; then
      return 0
    fi
  done <<EOF
$roles_tsv
EOF
  # Got here: cmux fully resolved, title is clean, NO role matched.
  # Suppress reset — NEW-01 guard (a non-relay same-worktree session must not
  # zero prime/coach's shared counter).
  _crr_suppress=1
  return 0
}

_crr_role_check || true

[ "$_crr_suppress" = "1" ] && exit 0

# --- 6. fire reset -----------------------------------------------------------
if [ -n "$_crr_relay_script" ] && [ -f "$_crr_relay_script" ]; then
  bash "$_crr_relay_script" reset >/dev/null 2>&1 || true
fi
exit 0
