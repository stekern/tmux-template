# tmux-template
A bash script for creating and loading user-defined templates.

## Requirements
Add the following line to your `.tmux.conf`:
```
set -g base-index 1
```
This starts window numbering at 1 instead of 0.

## Usage
```
$ mv example-config.sh config.sh
$ ./tmux-template example1
```
Add your templates to `config.sh`.

A window is defined in the following format. Fields are separated by semicolons `;`
```
declare -A WINDOWS=(
 [WINDOW_NUMBER]="WINDOW_NAME;WINDOW_DIR;COMMAND_PANE_0;COMMAND_PANE_1;COMMAND_PANE_2"
)
```

E.g. this will set up one window with three panes, with vim in the first pane and npm in the second. The two trailing semicolons are responsible for creating the third pane (where no commands are run).
```
declare -A WINDOWS=(
 [1]="example_name;/home/stekern/Projects/CoolProject/;vim .;npm start;;"
)
```

There are more examples in the supplied config file.

## Demo
<img src="https://cdn.rawgit.com/stekern/tmux-template/master/demo.svg">

## Limitations
- You can only have 1, 2 or 3 three panes in a window
- You have to use full paths when specifying directories. Tilde expansion does not work
- The first window has to have window number 1
- Assumes tmux window ordering starts at 1 instead of 0
