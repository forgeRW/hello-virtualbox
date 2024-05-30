#!/bin/bash

source script/share_functions.sh

step_node_install_shell_function() {
    printf -v today_date '%(%Y-%m-%d)T\n' -1
    echo >> $HOME/.bashrc
    echo \# start: added nvm on $today_date >> $HOME/.bashrc
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$nvm_version/install.sh | bash
    echo \# stop: added nvm on $today_date >> $HOME/.bashrc
    echo Added support for nvm in the file $HOME/.bashrc 
}

step_node_install_lts() {
    NVM_DIR="$XDG_CONFIG_HOME/nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    nvm install --lts
    nvm -v
    node -v

}

run_step_node() {
    local question="Do you wish to install nvm for Node?"
    echo $question
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) echo $question $answer; break;;
            No ) echo $question $answer; return 0;;
        esac
    done

    local question2="What is the nvm version that you wish to download?"
    local question3="Do you wish to download the nvm version, replace_me?"
    ask_and_confirm_question "$question2" "$question3"
    local -i is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    if (( $is_successful == 1 )); then
        return 1
    fi
    local nvm_version=$my_answer
    nvm_version=${nvm_version#*v} # GitHub release includes the letter v but nvm version command excludes it

    # step_node_install_shell_function
    step_node_install_lts
}

run_step_node
