#!/usr/bin/env bash
#
# Copyright (C) 2018 Erlend Ekern <dev@ekern.me>
#
# Distributed under terms of the MIT license.


# NB: Tilde expansion does not currently work, so you need to use full paths. E.g. '/home/<user>/Documents/' instead of '~/Documents/'


# The window to select after tmux has finished setting up
DEFAULT_WINDOW=1
# The pane to select after tmux has finished setting up
DEFAULT_PANE=0

# User-defined templates
if [ "$SESSION_NAME" = "example1" ]; then
  # Creates one window with three panes
  WORKSPACE="/home/$(whoami)/"
  declare -A WINDOWS=( 
    [1]="WINDOW_NAME_1;$WORKSPACE;;;;"
  )
elif [ "$SESSION_NAME" = "example2" ]; then
  # Creates one window with three panes, with commands in the first and second pane
  WORKSPACE="/home/$(whoami)/"
  declare -A WINDOWS=( 
    [1]="WINDOW_NAME_1;$WORKSPACE;echo pane 1/3;echo pane 2/3;;"
  )
elif [ "$SESSION_NAME" = "example3" ]; then
  # Creates four windows:
  # One with three panes, with commands in the first and third pane
  # One with three panes, with commands in the second pane
  # One with two panes, with commands in the first pane
  # One with one pane, with commands in the first pane
  WORKSPACE="/home/$(whoami)/"
  declare -A WINDOWS=( 
    [1]="WINDOW_NAME_1;$WORKSPACE;echo pane 1/3;;echo pane 3/3"
    [2]="WINDOW_NAME_2;$WORKSPACE;;echo pane 2/3;;"
    [3]="WINDOW_NAME_3;$WORKSPACE;echo pane 1/2;;"
    [4]="WINDOW_NAME_4;$WORKSPACE;echo pane 1/1"
  )
else
  # This is the default theme to use when no user templates matched the given session name
  # Creates one three-paned window named 'dev' and sets WORKSPACE to the folder the script was called from
  WORKSPACE="$PWD"
  declare -A WINDOWS=( 
    [1]="dev;$WORKSPACE;;;;"
  )
fi
