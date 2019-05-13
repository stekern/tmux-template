#!/usr/bin/env bash
#
# tmux-template.sh
# Copyright (C) 2018 Erlend Ekern <dev@ekern.me>
#
# Distributed under terms of the MIT license.
#

if [ $# -ne 1 ]; then
    echo "Usage: ./$0 <session_name>"
    exit 1;
fi

SESSION_NAME="$1"

# Load user template matching given session name
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $DIR/config.sh

# Maximize current window if wmctrl is installed
dpkg -s wmctrl > /dev/null 2>&1 && wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz

# Attach to session if it exists, else create a new one
tmux attach -t "$SESSION_NAME" > /dev/null 2>&1 ||
{
  # Loop through and set up the different windows for the given template
  for window_number in ${!WINDOWS[@]}; do
    # Load window configuration into an array
    OIFS="$IFS"
    IFS=';'
    window=($(echo "${WINDOWS[$window_number]}"))
    IFS="$OIFS"

    window_name="${window[0]}"
    window_dir="${window[1]}"
    pane_commands=("${window[@]:2}")
    num_panes="${#pane_commands[@]}"

    if [ "$window_number" -eq 1 ]; then
      # This is the first window -> create new session
      tmux new-session -d -s "$SESSION_NAME" -n "$window_name" -c "$window_dir"
      tmux set-option -t "$SESSION_NAME" base-index 1
      base_index=$(tmux list-windows -t "$SESSION_NAME" | cut -d: -f1)
      if [ "$base_index" -ne 1 ]; then
        tmux move-window -s "$SESSION_NAME:$base_index" -t "$SESSION_NAME:1"
      fi
      pane_base_index=$(tmux list-panes -t "$SESSION_NAME:1" | cut -d: -f1)
    else
      # A session has already been created -> create new window
      tmux new-window -t "$SESSION_NAME:$window_number" -n "$window_name" -c "$window_dir"
    fi

    if [ "$num_panes" -eq 3 ]; then
      # Make a horizontal split followed by a vertical split in the right pane
      tmux split-window -t "$SESSION_NAME:$window_number" -h -p "$pane_base_index" -c "$window_dir"
      tmux split-window -t "$SESSION_NAME:$window_number" -v -c "$window_dir"
    elif [ "$num_panes" -eq 2 ]; then
      # Make a 50/50 horizontal split
      tmux split-window -t "$SESSION_NAME:$window_number" -h -c "$window_dir"
    fi

    # Run given commands in their respective panes
    for i in "${!pane_commands[@]}"; do
      pane_command="${pane_commands[$i]}"
      if [ ! -z "$pane_command" ]; then
        tmux send-keys -t "$SESSION_NAME:$window_number.$((pane_base_index + i))" "$pane_command" C-m
      fi
    done
    tmux select-window -t "$SESSION_NAME:$window_number"
    tmux select-pane -t "$SESSION_NAME:$window_number.$pane_base_index"
  done

  # Select default window and pane
  tmux select-window -t "$SESSION_NAME:$DEFAULT_WINDOW"
  tmux select-pane -t "$SESSION_NAME:$DEFAULT_WINDOW.$((pane_base_index + DEFAULT_PANE))"

  tmux attach -t "$SESSION_NAME"
}
