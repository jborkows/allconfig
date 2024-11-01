#!/bin/bash
pushd "$HOME/.config/ansible/migrations" || exit
ansible-playbook  playbook.yml 
popd || exit
