# tmux-template
A bash script for creating and loading user-defined tmux templates.

## Usage
```
$ cp example-config.sh config.sh
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
- Window templates are hardcoded depending on the number of panes:
   - 1 pane (_fullscreen_):
    ```
     |-----------|
     |           |
     |     #1    |
     |           |
     |-----------|
    ```
   - 2 panes (_50/50 vertical split_):
    ```
     |-----------|
     |     |     |
     | #1  | #2  |
     |     |     |
     |-----------|
     ```
   - 3 panes (_70/30 vertical split, 50/50 horizontal split_):
    ```
     |------------|
     |       | #2 |
     |  #1   |----|
     |       | #3 |
     |------------|
    ```
