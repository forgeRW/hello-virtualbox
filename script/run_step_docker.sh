#!/bin/bash

source script/share_functions.sh

step_docker_add_courtesy_reminder() {
    declare -a some_array=(
        "Installing Docker Engine with the apt repository requires a password."
        "Will you provide the password if prompted?"
        )
    ask_and_confirm_manual_action "${some_array[@]}"
}

step_docker_add_gpg_key() {
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
}

step_docker_add_apt_repository() {
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
}

step_docker_install_engine() {
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

step_docker_add_user() {
    sudo groupadd docker
    sudo usermod -aG docker $USER
}

run_step_docker() {
    local question="Do you wish to install Docker with the latest version?"
    echo $question
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) echo $question $answer; break;;
            No ) echo $question $answer; return 0;;
        esac
    done

    step_docker_add_courtesy_reminder
    step_docker_add_gpg_key
    step_docker_add_apt_repository
    step_docker_install_engine
    step_docker_add_user
}

run_step_docker