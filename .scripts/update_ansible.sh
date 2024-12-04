#!/bin/bash
pushd "$HOME/.config/ansible/migrations" || exit
ansible-playbook  playbook.yml  --extra-vars "docker_data_dir=/datadisk/dockerdir"
popd || exit
