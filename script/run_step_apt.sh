#!/bin/bash

source script/share_functions.sh

step_apt_add_courtesy_reminder() {
    declare -a some_array=(
        "Installing system libraries requires a password."
        "Will you provide the password if prompted?"
        )
    ask_and_confirm_manual_action "${some_array[@]}"
}

step_apt_install_packages() {
    sudo apt-get install -y curl
}

run_step_apt() {
    local question="Do you wish to install curl?"
    echo $question
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) echo $question $answer; break;;
            No ) echo $question $answer; return 0;;
        esac
    done

    step_apt_add_courtesy_reminder
    step_apt_install_packages
}

run_step_apt