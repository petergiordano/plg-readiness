#!/usr/bin/env bash
# cmux-relay-topology.sh — SessionStart hook. Resolves the cmux-relay topology
# (where am I, where are my peers) and prints one context block to stdout, which
# the SessionStart hook injects as session context.
#
# ALWAYS exits 0 — it must never block session start. Every failure mode degrades
# to a single `cmux-relay: inactive (<reason>)` line. Targets bash 3.2.
#
# See the cmux-relay build spec §3.
set -uo pipefail

# --- locate + source the shared lib ------------------------------------------
# Prefer a sibling lib (dev tree / staged skill dir); fall back to the staged
# skill-library path (for a copied-into-.claude/hooks/ hook).
_crt_self_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd -P)"
_crt_lib=""
if [ -n "$_crt_self_dir" ] && [ -f "$_crt_self_dir/cmux-relay-lib.sh" ]; then
  _crt_lib="$_crt_self_dir/cmux-relay-lib.sh"
elif [ -f "$HOME/.claude/skill-library/cmux-relay/cmux-relay-lib.sh" ]; then
  _crt_lib="$HOME/.claude/skill-library/cmux-relay/cmux-relay-lib.sh"
fi
if [ -z "$_crt_lib" ]; then
  echo "cmux-relay: inactive (cmux-relay-lib.sh not found)"
  exit 0
fi
# shellcheck source=/dev/null
. "$_crt_lib"

# --- 1. inside a cmux surface at all? ----------------------------------------
if [ -z "${CMUX_SURFACE_ID:-}" ] && [ -z "${CMUX_WORKSPACE_ID:-}" ]; then
  echo "cmux-relay: inactive (not in a cmux surface)"
  exit 0
fi

# --- 2. root + config resolution ---------------------------------------------
if ! cmux_relay_resolve_root; then
  echo "cmux-relay: inactive (no config)"
  exit 0
fi
_crt_config="$CMUX_RELAY_CONFIG_PATH"

# --- 3. cmux + jq available? -------------------------------------------------
_crt_cmux="$(cmux_relay_resolve_cmux)" || { echo "cmux-relay: inactive (cmux unavailable)"; exit 0; }
_crt_jq="$(cmux_relay_resolve_jq)"     || { echo "cmux-relay: inactive (cmux unavailable)"; exit 0; }

# --- 4. self-location: cmux identify -> .caller.surface_ref ------------------
# Two distinct failure modes deserve distinct messages (capability-gap Rec 5,
# 2026-05-15):
#   (a) `cmux identify` exits non-zero -> cmux is genuinely unavailable.
#   (b) `cmux identify` succeeds but .caller.surface_ref is null -> the
#       session is DETACHED (running outside its cmux surface). Relay role
#       detection requires the session to start INSIDE its cmux surface so
#       cmux can bind the process to a surface ref. Generic "cmux unavailable"
#       is misleading here — the fix is to restart the session inside the
#       intended cmux surface, not to install cmux.
_crt_identify="$("$_crt_cmux" identify 2>/dev/null)" \
  || { echo "cmux-relay: inactive (cmux unavailable)"; exit 0; }
_crt_caller_ref="$(printf '%s' "$_crt_identify" \
  | "$_crt_jq" -r '.caller.surface_ref // empty' 2>/dev/null)"
if [ -z "$_crt_caller_ref" ]; then
  echo "cmux-relay: inactive (detached caller — no cmux surface_ref; start this session inside its cmux surface for role auto-detection. Relay ops to peers still work, but THIS session won't be auto-assigned a role.)"
  exit 0
fi

# --- 5. tree -> caller's title -----------------------------------------------
_crt_tree="$("$_crt_cmux" tree --json 2>/dev/null)" \
  || { echo "cmux-relay: inactive (cmux unavailable)"; exit 0; }
if [ -z "$_crt_tree" ]; then
  echo "cmux-relay: inactive (cmux unavailable)"
  exit 0
fi
_crt_my_title="$(printf '%s' "$_crt_tree" | "$_crt_jq" -r --arg ref "$_crt_caller_ref" '
  [ .windows[]?.workspaces[]?.panes[]?.surfaces[]? | select(.ref == $ref) | .title ]
  | .[0] // empty
' 2>/dev/null)"
if [ -z "$_crt_my_title" ]; then
  echo "cmux-relay: inactive (cmux unavailable)"
  exit 0
fi

# --- 6. role lookup (case-insensitive, exact-one) ----------------------------
_crt_roles_tsv="$("$_crt_jq" -r '.roles | to_entries[] | "\(.key)\t\(.value)"' \
  "$_crt_config" 2>/dev/null)"
if [ -z "$_crt_roles_tsv" ]; then
  echo "cmux-relay: inactive (no config)"
  exit 0
fi

_crt_tab="$(printf '\t')"
_crt_my_title_lc="$(printf '%s' "$_crt_my_title" | tr '[:upper:]' '[:lower:]')"
_crt_my_role=""
_crt_role_ambiguous=0
while IFS="$_crt_tab" read -r _role _title; do
  [ -z "$_role" ] && continue
  _title_lc="$(printf '%s' "$_title" | tr '[:upper:]' '[:lower:]')"
  if [ "$_title_lc" = "$_crt_my_title_lc" ]; then
    [ -n "$_crt_my_role" ] && _crt_role_ambiguous=1
    _crt_my_role="$_role"
  fi
done <<EOF
$_crt_roles_tsv
EOF

if [ "$_crt_role_ambiguous" = "1" ]; then
  echo "cmux-relay: inactive (ambiguous: title \"$_crt_my_title\" maps to multiple roles)"
  exit 0
fi
if [ -z "$_crt_my_role" ]; then
  echo "cmux-relay: inactive (surface \"$_crt_my_title\" not a configured role)"
  exit 0
fi

# --- 7. emit the context block -----------------------------------------------
_crt_workspace="$("$_crt_jq" -r '.workspace // "unknown"' "$_crt_config" 2>/dev/null)"
_crt_cap="$("$_crt_jq" -r '.relay.cap_round_trips // 2' "$_crt_config" 2>/dev/null)"
_crt_relay_script="$(cmux_relay_resolve_relay_script "$_crt_config" "$_crt_jq")"

echo "cmux-relay: active"
echo "  workspace: $_crt_workspace"
echo "  config: $_crt_config"
echo "  this session: role=$_crt_my_role title=$_crt_my_title surface=$_crt_caller_ref"
echo "  peers:"
while IFS="$_crt_tab" read -r _role _title; do
  [ -z "$_role" ] && continue
  [ "$_role" = "$_crt_my_role" ] && continue
  _ref="$(cmux_relay_resolve_one "$_crt_jq" "$_crt_tree" "$_title")"
  echo "    $_role: title=$_title surface=$_ref"
done <<EOF
$_crt_roles_tsv
EOF
echo "  relay cap: $_crt_cap round-trips"
echo "  skill: cmux-relay   (invoke for relay protocol)"
echo "  relay script: $_crt_relay_script"
exit 0
