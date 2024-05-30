#!/bin/bash

source script/share_functions.sh

step_go_download_and_extract_tarball() {
    create_directory_if_absent "$go_dir"
    wget -qO- https://go.dev/dl/go$go_version.linux-amd64.tar.gz | tar xz -C $go_dir
}

step_go_add_path() {
    local go_path=$go_dir/go/bin/go
    ln -sf $go_path $HOME/bin/go$go_version
    ln -sf $go_path $HOME/bin/go
    go version
}

run_step_go() {
    local question="Do you wish to install Go?"
    echo $question
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) echo $question $answer; break;;
            No ) echo $question $answer; return 0;;
        esac
    done

    local question2="What is the Go version that you wish to download?"
    local question3="Do you wish to download the Go version, replace_me?"
    ask_and_confirm_question "$question2" "$question3"
    local -i is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    if (( $is_successful == 1 )); then
        return 1
    fi
    local go_version=$my_answer

    local default_download_dir=$(cat $(pwd)/output/default_download_dir.txt)    
    local question4="Do you wish to download Go to the directory, $default_download_dir?"
    confirm_default_download_dir "$question4"
    is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    local go_dir
    if (( $is_successful == 0 )); then
        go_dir=$default_download_dir
    fi
    if [[ -z "$go_dir" ]]; then
        local question5="What is the absolute path to the destination directory for Go?"
        local question6="Do you wish to download Go to the directory, replace_me?"
        ask_and_confirm_question "$question5" "$question6"
        is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
        if (( $is_successful == 1 )); then
            return 1
        fi
        if [[ -n "$my_answer" ]]; then
            echo $my_answer > $(pwd)/output/default_download_dir.txt
        fi
        go_dir=$my_answer
    fi
    go_dir=$go_dir/go/go-$go_version

    step_go_download_and_extract_tarball
    step_go_add_path
}

run_step_go