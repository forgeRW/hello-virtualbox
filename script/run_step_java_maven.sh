#!/bin/bash

source script/share_functions.sh

step_maven_download_and_extract_tarball() {
    wget -P $(pwd)/output/java-maven https://dlcdn.apache.org/maven/maven-3/$maven_version/binaries/apache-maven-$maven_version-bin.tar.gz
    wget -P $(pwd)/output/java-maven-auxiliary https://downloads.apache.org/maven/maven-3/$maven_version/binaries/apache-maven-$maven_version-bin.tar.gz.sha512

    echo "$(cat $(pwd)/output/java-maven-auxiliary/apache-maven-$maven_version-bin.tar.gz.sha512)" $(pwd)/output/java-maven/apache-maven-$maven_version-bin.tar.gz | sha512sum -c

    create_directory_if_absent "$maven_dir"
    tar -xzf $(pwd)/output/java-maven/apache-maven-$maven_version-bin.tar.gz -C $maven_dir
    echo Downloaded Maven to the directory $maven_dir
}

step_maven_add_path() {
    local maven_path=$maven_dir/apache-maven-$maven_version/bin/mvn
    ln -sf $maven_path $HOME/bin/mvn$maven_version
    ln -sf $maven_path $HOME/bin/mvn
    mvn -v
}

step_maven_delete_auxiliary_files() {
    rm -rf $(pwd)/output/java-maven $(pwd)/output/java-maven-auxiliary
    echo Deleted the directory $(pwd)/output/java-maven
    echo Deleted the directory $(pwd)/output/java-maven-auxiliary
}

run_step_maven() {
    local question="Do you wish to install Maven?"
    echo $question
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) echo $question $answer; break;;
            No ) echo $question $answer; return 0;;
        esac
    done

    local question2="What is the Maven version that you wish to download?"
    local question3="Do you wish to download the Maven version, replace_me?"
    ask_and_confirm_question "$question2" "$question3"
    local -i is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    if (( $is_successful == 1 )); then
        return 1
    fi
    local maven_version=$my_answer

    local default_download_dir=$(cat $(pwd)/output/default_download_dir.txt)    
    local question4="Do you wish to download Maven to the directory, $default_download_dir?"
    confirm_default_download_dir "$question4"
    is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    local maven_dir
    if (( $is_successful == 0 )); then
        maven_dir=$default_download_dir
    fi
    if [[ -z "$maven_dir" ]]; then
        local question5="What is the absolute path to the destination directory for Maven?"
        local question6="Do you wish to download Maven to the directory, replace_me?"
        ask_and_confirm_question "$question5" "$question6"
        is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
        if (( $is_successful == 1 )); then
            return 1
        fi
        if [[ -n "$my_answer" ]]; then
            echo $my_answer > $(pwd)/output/default_download_dir.txt
        fi
        maven_dir=$my_answer
    fi
    maven_dir=$maven_dir/java-maven

    step_maven_download_and_extract_tarball
    step_maven_add_path

    local question7="Do you wish to delete the auxiliary files for Maven?"
    echo $question7
    select answer7 in "Yes" "No"; do
        case $answer7 in
            Yes ) echo $question7 $answer7; break;;
            No ) echo $question7 $answer7; return 0;;
        esac
    done

    step_maven_delete_auxiliary_files
}

run_step_maven