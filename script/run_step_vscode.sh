#!/bin/bash

source script/share_functions.sh

step_vscode_download_and_extract_tarball() {
    create_directory_if_absent "$vscode_dir"
    local vscode_url=$(curl -e robots=off https://update.code.visualstudio.com/$vscode_version/linux-x64/stable)
    vscode_url=https:${vscode_url#*https:}
    wget -qO- $vscode_url | tar xz -C $vscode_dir
    echo Downloaded VS Code to the directory $vscode_dir
}

step_vscode_add_desktop_shortcut() {
    local desktop_shortcut_path=$HOME/Desktop/vscode.desktop
    echo [Desktop Entry] > $desktop_shortcut_path
    echo Type=Application >> $desktop_shortcut_path
    echo Name=vscode >> $desktop_shortcut_path
    local exec_path=$(find $vscode_dir | grep bin/code$)
    echo Exec=$exec_path --no-sandbox >> $desktop_shortcut_path
    local icon_path=$(find $vscode_dir | grep code.png)
    echo Icon=$icon_path >> $desktop_shortcut_path
    gio set $desktop_shortcut_path "metadata::trusted" true
    echo Created desktop shortcut at $desktop_shortcut_path
}

run_step_vscode() {
    local question="Do you wish to install VS Code?"
    echo $question
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) echo $question $answer; break;;
            No ) echo $question $answer; return 0;;
        esac
    done

    local question2="What is the VS Code version that you wish to download?"
    local question3="Do you wish to download the VS Code version, replace_me?"
    ask_and_confirm_question "$question2" "$question3"
    local -i is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    if (( $is_successful == 1 )); then
        return 1
    fi
    local vscode_version=$my_answer

    local default_download_dir=$(cat $(pwd)/output/default_download_dir.txt)    
    local question4="Do you wish to download VS Code to the directory, $default_download_dir?"
    confirm_default_download_dir "$question4"
    is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    local vscode_dir
    if (( $is_successful == 0 )); then
        vscode_dir=$default_download_dir
    fi
    if [[ -z "$vscode_dir" ]]; then
        local question5="What is the absolute path to the destination directory for VS Code?"
        local question6="Do you wish to download VS Code to the directory, replace_me?"
        ask_and_confirm_question "$question5" "$question6"
        is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
        if (( $is_successful == 1 )); then
            return 1
        fi
        if [[ -n "$my_answer" ]]; then
            echo $my_answer > $(pwd)/output/default_download_dir.txt
        fi
        vscode_dir=$my_answer
    fi
    vscode_dir=$vscode_dir/vscode

    step_vscode_download_and_extract_tarball
    step_vscode_add_desktop_shortcut
}

run_step_vscode