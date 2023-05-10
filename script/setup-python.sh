#!/bin/bash

set -x


# Common variables

SOURCES_LIST=/etc/apt/sources.list
PYTHON_DIR_VER=$PYTHON_DIR/Python-$PYTHON_VERSION
MY_PYTHON_DIR=$PYTHON_DIR/my-python-$PYTHON_VERSION
VENV_DIR=$MY_PYTHON_DIR/my-venv


step01() {
  # Add location for Python source package
  local source_location='deb-src http://archive.ubuntu.com/ubuntu/ jammy main'

  cp $SOURCES_LIST $HOME
  printf "\n${source_location}" | sudo tee -a $SOURCES_LIST
}

step02() {
  # Install dependencies
  sudo apt update
  sudo apt build-dep -y python3
  sudo apt install -y pkg-config
  sudo apt install -y build-essential gdb lcov pkg-config \
    libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
    libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
    lzma lzma-dev tk-dev uuid-dev zlib1g-dev
}

step03() {
  # Remove location for Python source package
  local home_sources_list=$HOME/sources.list

  sudo cp $home_sources_list $SOURCES_LIST
  sudo rm $home_sources_list
  mkdir $PYTHON_DIR
}

step04() {
  # Build binaries for the specified Python version
  mkdir $MY_PYTHON_DIR $VENV_DIR
  wget -O- $PYTHON_URL | tar -xz -C $PYTHON_DIR
  pushd $PYTHON_DIR_VER
  ./configure --prefix=$MY_PYTHON_DIR
  make -s -j2
  make altinstall
  popd
}

step05() {
  # Create symbolic links to Python and pip binaries
  local ver_no_patch=$(echo "$PYTHON_VERSION" | sed -r 's/^([0-9]+\.[0-9]+).*$/\1/')
  local bin_python=$MY_PYTHON_DIR/bin/python$ver_no_patch
  local bin_pip=$MY_PYTHON_DIR/bin/pip$ver_no_patch
  local my_bin_python=$MY_BIN/my-python
  local my_bin_pip=$MY_BIN/my-pip

  ln -s $bin_python $my_bin_python$ver_no_patch
  ln -s $bin_pip $my_bin_pip$ver_no_patch
  ln -s $bin_python $my_bin_python
  ln -s $bin_pip $my_bin_pip
}

run_main() {
  step01
  step02
  step03
  step04
  step05
}

run_main
