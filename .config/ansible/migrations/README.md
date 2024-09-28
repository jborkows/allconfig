# Additional commands:
## Add binding for managing windows using fzf

### Command for closing windows using fzf
```bash
konsole -e "bash -c 'source [FULL_PATH_TO_HOME]/.fzf.bash && wmctrl list -l | fzf --multi | cut -f0 -d\" \" | xargs -I {} wmctrl -i -c {}'"
```
### Command for switching between windows using fzf
```bash
konsole -e "bash -c 'source /home/jborkows/.fzf.bash && echo $PATH && wmctrl list -l | fzf  | cut -f1 -d\" \" | xargs -I {} wmctrl -i -R {} '"
```
### use kitty
### Add bindings
Add binding using command:
/bin/bash script file

