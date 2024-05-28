#!/bin/bash

source script/share_functions.sh

step_python_download_and_extract_tarball() {
    create_directory_if_absent "$python_source_dir"
    wget -qO- https://www.python.org/ftp/python/$python_version/Python-$python_version.tgz | tar xz -C $python_source_dir
    echo Downloaded Python to the directory $python_source_dir
}

step_python_add_courtesy_reminder() {
    declare -a some_array=(
        "Compiling Python requires additional system libraries."
        "Installing system libraries requires a password."
        "Will you provide the password if prompted?"
        )
    ask_and_confirm_manual_action "${some_array[@]}"
}

step_python_install_dependencies() {
    sudo apt-get install -y gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev libmpdec-dev
    echo Finished installing system libraries for Python
}

step_python_compile_source() {
    create_directory_if_absent "$python_dir"
    create_directory_if_absent "$python_dir/Python-$python_version"

    pushd $python_source_dir/Python-$python_version
    ./configure --prefix=$python_dir/Python-$python_version
    make -j $(nproc)
    make altinstall
    popd
    
    echo Compiled Python to the directory $python_dir
}

step_python_add_path() {
    local minor_version=${python_version%.*}
    local python_path=$python_dir/Python-$python_version/bin/python$minor_version
    ln -sf $python_path $HOME/bin/my-python$python_version
    ln -sf $python_path $HOME/bin/my-python
    my-python -V
    
    local pip_path=$python_dir/Python-$python_version/bin/pip$minor_version
    ln -sf $pip_path $HOME/bin/my-pip$python_version
    ln -sf $pip_path $HOME/bin/my-pip
    my-pip -V
}

run_step_python() {
    local question="Do you wish to install Python?"
    echo $question
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) echo $question $answer; break;;
            No ) echo $question $answer; return 0;;
        esac
    done

    local question2="What is the Python version that you wish to download?"
    local question3="Do you wish to download the Python version, replace_me?"
    ask_and_confirm_question "$question2" "$question3"
    local -i is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    if (( $is_successful == 1 )); then
        return 1
    fi
    local python_version=$my_answer

    local default_download_dir=$(cat $(pwd)/output/default_download_dir.txt)    
    local question4="Do you wish to download Python to the directory, $default_download_dir?"
    confirm_default_download_dir "$question4"
    is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
    local python_dir
    if (( $is_successful == 0 )); then
        python_dir=$default_download_dir
    fi
    if [[ -z "$python_dir" ]]; then
        local question5="What is the absolute path to the destination directory for Python?"
        local question6="Do you wish to download Python to the directory, replace_me?"
        ask_and_confirm_question "$question5" "$question6"
        is_successful=$(echo $?) # 0 is successful. 1 is unsuccessful.
        if (( $is_successful == 1 )); then
            return 1
        fi
        if [[ -n "$my_answer" ]]; then
            echo $my_answer > $(pwd)/output/default_download_dir.txt
        fi
        python_dir=$my_answer
    fi
    python_dir=$python_dir/my-python
    python_source_dir=$python_dir-source

    step_python_download_and_extract_tarball
    step_python_add_courtesy_reminder
    step_python_install_dependencies
    step_python_compile_source
    step_python_add_path
}

run_step_python