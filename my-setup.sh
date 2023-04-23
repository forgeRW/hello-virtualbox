#!/bin/bash

set -x


# Package URLs

VS_CODE='https://az764295.vo.msecnd.net/stable/704ed70d4fd1c6bd6342c436f1ede30d1cff4710/code-stable-x64-1681293081.tar.gz'

INTELLIJ='https://download-cdn.jetbrains.com/idea/ideaIC-2023.1.tar.gz'

GO_VERSION='1.20.3'
GO_URL="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"

NVM_VERSION='0.39.3'
NVM_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh"

PYTHON_VERSION='3.10.11'
PYTHON_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"


# Common variables

ALIASES_FILE=$HOME/.bash_aliases
MY_BIN=$HOME/bin
MY_DEV=$HOME/dev
IDE_DIR=$MY_DEV/ide
GO_DIR=$MY_DEV/go
PYTHON_DIR=$MY_DEV/python


generate_desktop_entry() {
  local entry_path=$HOME/Desktop/$1
  local entry_exec=$2
  local entry_icon=$3
  local entry_name=$4

  echo [Desktop Entry] > $entry_path
  echo Type=Application >> $entry_path
  echo "Exec=${entry_exec}" >> $entry_path
  echo "Icon=${entry_icon}" >> $entry_path
  echo "Name=${entry_name}" >> $entry_path
}

step901() {
  # Set up SSH configuration for OpenSSH server.
  local putty_pub=$HOME/my-setup-ed25519.pub
  local ssh_dir=$HOME/.ssh
  local ssh_key=$ssh_dir/id_ed25519_virtualbox
  local ssh_pub=$ssh_key.pub
  local authorized_keys=$ssh_dir/authorized_keys

  mkdir $ssh_dir
  chmod 700 $ssh_dir
  ssh-keygen -i -f $putty_pub > $ssh_pub
  rm $putty_pub
  cat $ssh_pub >> $authorized_keys
  chmod 600 $authorized_keys
}

step902() {
  # Install cURL and jq packages.
  sudo apt install -y curl jq
}

step903() {
  # Create .bash_aliases file and bin and IDE directories.
  touch $ALIASES_FILE
  mkdir $MY_BIN
  mkdir $IDE_DIR
}

step904() {
  # Install IntelliJ IDE.
  wget -O- $INTELLIJ | tar -xz -C $IDE_DIR
}

step905() {
  # Install Visual Studio Code IDE.
  local vs_code_dir=$IDE_DIR/VSCode-linux-x64
  local entry_path=visual_studio_code.desktop
  local entry_exec=$vs_code_dir/bin/code
  local entry_icon=$vs_code_dir/resources/app/resources/linux/code.png
  local entry_name='Visual Studio Code'

  wget -O- $VS_CODE | tar -xz -C $IDE_DIR
  generate_desktop_entry $entry_path $entry_exec $entry_icon "${entry_name}"
}

step906() {
  # Install Go/Golang
  local go_bin=$GO_DIR/go$GO_VERSION/bin
  local bin_go=$go_bin/go
  local bin_gofmt=$go_bin/gofmt
  local my_bin_go=$MY_BIN/go
  local my_bin_gofmt=$MY_BIN/gofmt
  local gopath=$HOME/go

  mkdir $GO_DIR
  wget -O- $GO_URL | tar -xz -C $GO_DIR
  mv $GO_DIR/go $GO_DIR/go$GO_VERSION
  ln -s $bin_go $my_bin_go$GO_VERSION
  ln -s $bin_gofmt $my_bin_gofmt$GO_VERSION
  ln -s $bin_go $my_bin_go
  ln -s $bin_gofmt $my_bin_gofmt
  mkdir $gopath
}

step907() {
  #Install Node.js/JavaScript
  wget -qO- $NVM_URL | bash
}

step908() {
  local setup_dir=$( cd -P "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  source $setup_dir/script/setup-python.sh
}

run_main() {
  step901
  step902
  step903
  step904
  step905
  step906
  step907
  step908
}

run_main
