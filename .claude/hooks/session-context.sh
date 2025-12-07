#!/bin/bash
# Session context hook - provides system info to Claude

# Get hostname with fallbacks
get_hostname() {
    local name
    # Try hostname command first
    name=$(hostname 2>/dev/null)
    # Fall back to /proc/sys/kernel/hostname
    [[ -z "$name" ]] && name=$(cat /proc/sys/kernel/hostname 2>/dev/null)
    # Fall back to /etc/hostname
    [[ -z "$name" ]] && name=$(cat /etc/hostname 2>/dev/null)
    # Final fallback
    [[ -z "$name" ]] && name="unknown"
    echo "$name"
}

# Get basic info
HOSTNAME=$(get_hostname)
OS_NAME=$(grep -oP '(?<=PRETTY_NAME=").*(?=")' /etc/os-release 2>/dev/null || uname -s)
WORK_DIR=$(pwd)

# Detect if running inside a container
is_container() {
    [[ -n "$container" ]] || [[ -f /.containerenv ]] || [[ -f /.dockerenv ]]
}

# Detect environment
if is_container; then
    # Inside a container/pod
    ENV_TYPE="container"
    # Use IMAGE_NAME if available, otherwise generic description
    if [[ -n "$IMAGE_NAME" ]]; then
        ENV_DESC="Running inside container ($IMAGE_NAME)."
    else
        ENV_DESC="Running inside a container."
    fi
    # Add workspace info if mounted
    [[ -d "/workspace" ]] && ENV_DESC="$ENV_DESC /workspace is mounted from host."
    JUPYTER_INFO=""
    # If hostname is a container ID (12+ hex chars), prefer IMAGE_NAME
    if [[ "$HOSTNAME" =~ ^[a-f0-9]{12} ]] && [[ -n "$IMAGE_NAME" ]]; then
        HOSTNAME="$IMAGE_NAME"
    fi
elif [[ -d "$HOME/.config/jupyter" ]] && [[ -n "$(ls -A $HOME/.config/jupyter/*.env 2>/dev/null)" ]]; then
    # Host system with Jupyter quadlets
    ENV_TYPE="host-with-jupyter"

    # Count instances and their status
    RUNNING=0
    STOPPED=0
    for env_file in $HOME/.config/jupyter/*.env; do
        instance=$(basename "$env_file" .env)
        if systemctl --user is-active --quiet "jupyter-${instance}.service" 2>/dev/null; then
            ((RUNNING++))
        else
            ((STOPPED++))
        fi
    done

    TOTAL=$((RUNNING + STOPPED))
    ENV_DESC="Host system with Jupyter quadlets installed."
    JUPYTER_INFO="Jupyter: $TOTAL instances ($RUNNING running, $STOPPED stopped)."
else
    # Regular host system
    ENV_TYPE="host"
    ENV_DESC="Host system without Jupyter quadlets."
    JUPYTER_INFO=""
fi

# Detect GPU
GPU_INFO=""
if command -v nvidia-smi &>/dev/null && nvidia-smi &>/dev/null; then
    GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
    GPU_INFO="GPU: $GPU_NAME."
elif [[ -d /sys/class/drm ]]; then
    for card in /sys/class/drm/card*/device/vendor; do
        if [[ -f "$card" ]]; then
            vendor=$(cat "$card" 2>/dev/null)
            case "$vendor" in
                0x1002) GPU_INFO="GPU: AMD (detected)." ;;
                0x8086) GPU_INFO="GPU: Intel (detected)." ;;
            esac
            [[ -n "$GPU_INFO" ]] && break
        fi
    done
fi
[[ -z "$GPU_INFO" ]] && GPU_INFO="GPU: None detected."

# Build context message
CONTEXT="System: $HOSTNAME ($OS_NAME). Working directory: $WORK_DIR. Environment: $ENV_TYPE - $ENV_DESC"
[[ -n "$JUPYTER_INFO" ]] && CONTEXT="$CONTEXT $JUPYTER_INFO"
CONTEXT="$CONTEXT $GPU_INFO"

# Output JSON for Claude
cat << EOF
{
  "decision": "approve",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$CONTEXT"
  }
}
EOF
