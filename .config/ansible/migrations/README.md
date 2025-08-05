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

## Missing:
~/projects/allconfig/.scripts$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 16631  100 16631    0     0  85732      0 --:--:-- --:--:-- --:--:-- 86170
=> Downloading nvm from git to '/home/jborkows/.nvm'
=> Cloning into '/home/jborkows/.nvm'...
remote: Enumerating objects: 383, done.
remote: Counting objects: 100% (383/383), done.
remote: Compressing objects: 100% (326/326), done.
remote: Total 383 (delta 43), reused 179 (delta 29), pack-reused 0 (from 0)
Receiving objects: 100% (383/383), 392.12 KiB | 3.38 MiB/s, done.
Resolving deltas: 100% (43/43), done.
* (HEAD detached at FETCH_HEAD)
  master
=> Compressing and cleaning up git repository

=> Appending nvm source string to /home/jborkows/.bashrc
=> Appending bash_completion source string to /home/jborkows/.bashrc
=> Close and reopen your terminal to start using nvm or run the following to use it now:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts
mkdir .local/bin
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
mkdir programs
mkdir -p ~/.local/share/fonts
sudo apt install fonts-noto-color-emoji fonts-emojione
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
apt-get update && apt-get install carapace-bin

## TODO
Rewrite to bash script
