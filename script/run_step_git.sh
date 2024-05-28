#!/bin/bash

source script/share_functions.sh

step_git_process_ssh_key() {
    ssh-keygen -t ed25519 -N '' -C '' -f $ssh_dir/$my_ssh_key
    chmod 644 $ssh_dir/$my_ssh_key.pub
    chmod 600 $ssh_dir/$my_ssh_key

    local authorized_keys_file=$ssh_dir/authorized_keys
    cat $ssh_dir/$my_ssh_key.pub >> $authorized_keys_file
    chmod 600 $authorized_keys_file
    echo Added the public key to the file $authorized_keys_file
}

step_git_add_key() {
    declare -a some_array=(
        "Add the private key to the SSH Agent using the commands below"
        'eval "$(ssh-agent -s)"'
        "ssh-add $ssh_dir/$my_ssh_key"
        "Have you added the private key to the SSH Agent?"
        )
    ask_and_confirm_manual_action "${some_array[@]}"
}

step_git_add_public_key() {
    local public_ssh_key=$(cat $ssh_dir/$my_ssh_key.pub)
    declare -a some_array=(
        "The public key is shown below"
        "$public_ssh_key"
        "Have you added the public key to GitHub?"
        )
    ask_and_confirm_manual_action "${some_array[@]}"
}

run_step_git() {
    local question="Do you wish to configure the SSH connection to GitHub?"
    echo $question
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) echo $question $answer; break;;
            No ) echo $question $answer; return 0;;
        esac
    done

    local question2="What do you wish to name the SSH key?"
    local question3="Do you wish to name the SSH key, replace_me?"
    ask_and_confirm_question "$question2" "$question3"
    local -i is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    if (( $is_successful == 1 )); then
        return 1
    fi
    local my_ssh_key=$my_answer

    git --version
    local ssh_dir=$HOME/.ssh
    step_git_process_ssh_key
    step_git_add_key
    step_git_add_public_key
}

run_step_git
