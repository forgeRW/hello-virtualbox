# hello-virtualbox

The repository stores my notes for VirtualBox.

# Prerequisites

1. Some bash commands present prompts, e.g. yes/no, etc.

2. VirtualBox Guest Additions version: `6.1.40`.

3. We create and use the `$HOME/.bash_aliases` file for customizations for the `$HOME/.bashrc` file.

4. IntelliJ IDE version: `2023.1`. IntelliJ IDE build version: `231.8109.175`.

5. IntelliJ IDE downloads the latest OpenJDK version to the `$HOME/.jdks` directory.

<details>
  <summary>Check Java version</summary>

```bash
.jdks/openjdk-20.0.1/bin/java -version

Output:
openjdk version "20.0.1" 2023-04-18
OpenJDK Runtime Environment (build 20.0.1+9-29)
OpenJDK 64-Bit Server VM (build 20.0.1+9-29, mixed mode, sharing)
```
</details>

6.  IntelliJ IDE creates the `$HOME/IdeaProjects` directory for the Java repositories.

7. Go version: `1.20.3`. We download the Go versions to the `$HOME/dev/go` directory. A Go compiler expects the Go repositories to be in the `GOPATH` variable which is the `$HOME/go` directory by default. We install only one Go version so see [Managing Go installations](https://go.dev/doc/manage-install) for details about managing multiple Go versions.

<details>
  <summary>Check Go version</summary>

```bash
go version

Output:
go version go1.20.3 linux/amd64
```

```bash
go env
```
</details>

8. nvm version: `0.39.3`. Node.js version: `18.16.0`. npm version: `9.5.1`.

<details>
  <summary>Check nvm and Node.js versions</summary>

```bash
nvm --version

Output:
0.39.3
```

```bash
nvm install v18.16.0
nvm use node # equivalent to nvm use v18.16.0
which node

Output:
$HOME/.config/nvm/versions/node/v18.16.0/bin/node

which nvm

Output:
$HOME/.config/nvm/versions/node/v18.16.0/bin/nvm
```

```
node --version

Output:
v18.16.0

npm --version

Output:
9.5.1
```
</details>

9. Default (system) Python version: `3.10.6`. We have no `python -V` command by default.

<details>
  <summary>Check Python version</summary>

```bash
which python

Output: Nothing
```

```bash
which python3

Output:
/usr/bin/python3

python3 -V

Output:
Python 3.10.6
```
</details>

10. Our Python version: `3.10.11`. See [README.rst](https://github.com/python/cpython/blob/main/README.rst) and [Install dependencies](https://devguide.python.org/getting-started/setup-building/index.html#install-dependencies) for the latest installation instructions. We install only one Python version so see [pyenv](https://github.com/pyenv/pyenv#getting-pyenv) for managing multiple Python versions.

<details>
  <summary>Check Python version</summary>

```bash
my-python -V

Output:
Python 3.10.11

my-pip -V

Output:
pip 23.0.1 from $HOME/dev/python/my-python-3.10.11/lib/python3.10/site-packages/pip (python 3.10)
```
</details>

11. We use the `$HOME/dev/github.com` directory for the GitHub, Node.js, and Python repositories. We use the `$HOME/dev/python/my-python-X/my-venv` directory for the Python virtual environments. See [venv — Creation of virtual environments](https://docs.python.org/3.10/library/venv.html) for more details.

<details>
  <summary>Example using venv</summary>

```bash
my-python3.10 -m venv $HOME/dev/python/my-python-3.10.11/my-venv/env
source $HOME/dev/python/my-python-3.10.11/my-venv/env/bin/activate
python -V

Output:
Python 3.10.11
```

```bash
deactivate

Output: Nothing
```
</details>

# Instructions

1. Update and install packages.

```bash
sudo apt update && sudo apt upgrade -y
```

2. Install dependencies for VirtualBox Guest Additions so we can auto-resize the Guest display and use the shared clipboard and drag-and-drop features. See [2.3.2. The Oracle VM VirtualBox Kernel Modules](https://www.virtualbox.org/manual/UserManual.html#externalkernelmodules) for more details.

```bash
sudo apt install -y linux-headers-$(uname -r) build-essential dkms
```

3. Install VirtualBox Guest Additions. See [4.2.2.1. Installing the Linux Guest Additions](https://www.virtualbox.org/manual/UserManual.html#additions-linux) for more details. For example, if the version is `1.2.3` then the `VBox_GAs_X` value is `VBox_GAs_1.2.3`.

```bash
sudo sh /media/$(whoami)/VBox_GAs_X/VBoxLinuxAdditions.run
```

4. Install OpenSSH server so we can use SSH to share files between the host and guest machines.

```bash
sudo apt install -y openssh-sever
```

5. Edit the `PasswordAuthentication` option in OpenSSH server configuration. See [Disable Password Authentication](https://help.ubuntu.com/community/SSH/OpenSSH/Configuring) for more detail.

```bash
sudo nano /etc/ssh/sshd_config
```

In the `sshd_config` file, replace the line below:

```text
#PasswordAuthentication yes
```

with the line below:

```text
PasswordAuthentication no
```

6. Restart the VM for OpenSSH server and VirtualBox Guest Additions.

7. In the host machine, use the `PuTTY Key Generator` app to create an Ed25519 keypair.

8. Copy and paste the public key from the host to the guest machine. Save the public key as `$HOME/my-setup-ed25519.pub` in the guest machine.

9. Install Git package. Configure Git and update the `X` and `Y` values accordingly in the snippet below. Also update the SSH keypair and see [Adding a new SSH key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and [Notes: Generate SSH Keypair](#notes-generate-ssh-keypair) for more details.

```bash
sudo apt install -y git
```

```bash
GIT_USERNAME='X' && \
  GIT_EMAIL='Y' && \
  MY_SETUP=$HOME/dev/github.com/$GIT_USERNAME/hello-virtualbox
```

```bash
git config --global user.name $GIT_USERNAME && \
  git config --global user.email $GIT_EMAIL && \
  mkdir -p $MY_SETUP && \
  git clone git@github.com:forgeRW/hello-virtualbox.git $MY_SETUP
```

10. Run the `$HOME/dev/github.com/$GIT_USERNAME/hello-virtualbox/my-setup.sh` script.

```bash
source $HOME/dev/github.com/$GIT_USERNAME/hello-virtualbox/my-setup.sh
```

11. Restart the VM for the `$HOME/bin` directory and  nvm.

12. For IntelliJ IDE, use the `$HOME/dev/idea/idea-IC-X/idea.sh` script to create a desktop entry and see [Standalone installation](https://www.jetbrains.com/help/idea/installation-guide.html#standalone) for more details. For example, if the build version is `1.2.3` then the `idea-IC-X` value is `idea-IC-1.2.3`. See [Archived OpenJDK General-Availability Releases](https://jdk.java.net/archive) for more details about downloading older OpenJDK versions.

```bash
sh $HOME/dev/ide/idea-IC-X/bin/idea.sh
```

# Notes: Generate SSH Keypair

```bash
#!/bin/bash

set -x

SSH_DIR=$HOME/.ssh
SSH_KEY=$SSH_DIR/id_ed25519
SSH_PUB=$SSH_KEY.pub
AUHORIZED_KEYS=$SSH_DIR/authorized_keys

mkdir $SSH_DIR
chmod 700 $SSH_DIR
ssh-keygen -t ed25519 -N '' -C '' -f $SSH_KEY
chmod 644 $SSH_PUB
chmod 600 $SSH_KEY
cat $SSH_PUB >> $AUHORIZED_KEYS
chmod 600 $AUHORIZED_KEYS
eval "$(ssh-agent -s)"
ssh-add $SSH_KEY
```

# Notes: Example `.desktop` File

```text
[Desktop Entry]
Type=Application
Exec=/path/to/executable
Icon=/path/to/icon
Name=Hello Application
```
