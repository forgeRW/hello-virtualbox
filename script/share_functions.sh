#!/bin/bash

create_directory_if_absent() {
    local dir_name=$1
    if [ ! -d $dir_name ]; then
        mkdir -p $dir_name
        echo Created the directory $dir_name
    fi
}

confirm_default_download_dir() {
    if [[ -n "$default_download_dir" ]]; then
        local question=$1
        echo $question
        select answer in "Yes" "No"; do
            case $answer in
                Yes ) echo $question $answer; return 0;;
                No ) echo $question $answer; break;;
            esac
        done
    fi
    return 1
}

ask_and_confirm_question_once() {
    local question=$1
    echo $question
    read my_answer

    local question2=$2
    question2=${question2/replace_me/"$my_answer"}
    echo $question2
    select answer2 in "Yes" "No"; do
        case $answer2 in
        Yes ) echo $question2 $answer2; break;;
        No ) echo $question2 $answer2; return 1;;
        esac
    done
    return 0
}

ask_and_confirm_question() {
    local -i attempt=1
    local -i max_attempts=4
    local -i is_confirmed=1 # 0 is confirmed. 1 is not confirmed.
    while (( $attempt < $max_attempts )) && (( $is_confirmed == 1 )); do
        ask_and_confirm_question_once "$1" "$2"
        is_confirmed=$(echo $?)
        attempt=$((attempt + 1)) 
    done
    return $is_confirmed
}

ask_and_confirm_manual_action() {
    local some_array=("$@")
    local question=""
    echo !!! ATTENTION !!! IMPORTANT !!!
    for instruction in "${some_array[@]}"; do
        echo $instruction
        question=$instruction
    done
    select answer in "Yes"; do
        case $answer in
            Yes ) echo $question $answer; break;;
        esac
    done 
    return 0
}