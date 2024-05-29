#!/bin/bash

source script/share_functions.sh

step_java_download_and_extract_tarball() {
    wget -P $(pwd)/output/java https://corretto.aws/downloads/latest/amazon-corretto-$java_version-x64-linux-jdk.tar.gz
    wget -P $(pwd)/output/java-auxiliary https://corretto.aws/downloads/latest_sha256/amazon-corretto-$java_version-x64-linux-jdk.tar.gz
    wget -P $(pwd)/output/java-auxiliary https://corretto.aws/downloads/latest/amazon-corretto-$java_version-x64-linux-jdk.tar.gz.sig
    wget -P $(pwd)/output/java-auxiliary https://corretto.aws/downloads/latest/amazon-corretto-$java_version-x64-linux-jdk.tar.gz.pub

    echo "$(cat $(pwd)/output/java-auxiliary/amazon-corretto-$java_version-x64-linux-jdk.tar.gz)" $(pwd)/output/java/amazon-corretto-$java_version-x64-linux-jdk.tar.gz | sha256sum -c
    gpg --import $(pwd)/output/java-auxiliary/amazon-corretto-$java_version-x64-linux-jdk.tar.gz.pub
    gpg --verify $(pwd)/output/java-auxiliary/amazon-corretto-$java_version-x64-linux-jdk.tar.gz.sig $(pwd)/output/java/amazon-corretto-$java_version-x64-linux-jdk.tar.gz
    gpg --batch --yes --delete-key "Amazon Services LLC (Amazon Corretto release)"

    create_directory_if_absent "$java_dir"
    tar -xzf $(pwd)/output/java/amazon-corretto-$java_version-x64-linux-jdk.tar.gz -C $java_dir
    echo Downloaded Java to the directory $java_dir
}

step_java_add_path() {
    local java_path=$java_dir/$(ls $java_dir)/bin/java
    ln -sf $java_path $HOME/bin/java-$java_version
    ln -sf $java_path $HOME/bin/java
    java --version

    if [ ! -f $HOME/.bash_aliases ]; then
        touch $HOME/.bash_aliases
        echo Created the file $HOME/.bash_aliases
    fi
    echo "JDK_HOME=$java_dir/$(ls $java_dir)" >> $HOME/.bash_aliases
    echo 'JAVA_HOME=$JDK_HOME' >> $HOME/.bash_aliases
}

step_java_delete_auxiliary_files() {
    rm -rf $(pwd)/output/java $(pwd)/output/java-auxiliary
    echo Deleted the directory $(pwd)/output/java
    echo Deleted the directory $(pwd)/output/java-auxiliary
}

run_step_java() {
    local question="Do you wish to install Java?"
    echo $question
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) echo $question $answer; break;;
            No ) echo $question $answer; return 0;;
        esac
    done

    local question2="What is the Java version that you wish to download?"
    local question3="Do you wish to download the Java version, replace_me?"
    ask_and_confirm_question "$question2" "$question3"
    local -i is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    if (( $is_successful == 1 )); then
        return 1
    fi
    local java_version=$my_answer

    local default_download_dir=$(cat $(pwd)/output/default_download_dir.txt)    
    local question4="Do you wish to download Java to the directory, $default_download_dir?"
    confirm_default_download_dir "$question4"
    is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    local java_dir
    if (( $is_successful == 0 )); then
        java_dir=$default_download_dir
    fi
    if [[ -z "$java_dir" ]]; then
        local question5="What is the absolute path to the destination directory for Java?"
        local question6="Do you wish to download Java to the directory, replace_me?"
        ask_and_confirm_question "$question5" "$question6"
        is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
        if (( $is_successful == 1 )); then
            return 1
        fi
        if [[ -n "$my_answer" ]]; then
            echo $my_answer > $(pwd)/output/default_download_dir.txt
        fi
        java_dir=$my_answer
    fi
    java_dir=$java_dir/java

    step_java_download_and_extract_tarball
    step_java_add_path

    local question7="Do you wish to delete the auxiliary files for Java?"
    echo $question7
    select answer7 in "Yes" "No"; do
        case $answer7 in
            Yes ) echo $question7 $answer7; break;;
            No ) echo $question7 $answer7; return 0;;
        esac
    done

    step_java_delete_auxiliary_files
}

run_step_java
