#!/bin/bash

function guiRelatedWhichFailsOnAnsibleForSomeReasons() {
  echo "Post actions"
    xdg-settings set default-web-browser brave-browser.desktop
}

pushd "$HOME/.config/ansible/migrations" || exit
ansible-playbook  playbook.yml  --extra-vars "docker_data_dir=/datadisk/dockerdir"

cowsay -f dragon "Ansible playbook executed successfully"

popd || exit

guiRelatedWhichFailsOnAnsibleForSomeReasons

cowsay -f dragon "Script execution finished"

