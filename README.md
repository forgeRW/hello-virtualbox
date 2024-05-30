# hello-virtualbox

The repository stores my notes for using VirtualBox and setting up a VM.

# Prerequisites

1. The script has been tested with the items below. All items are installed in the shared folder except for Python. The shared folder is on the host machine and mounted to the Ubuntu guest machine. The Python sources and interpreters are on the guest machine to avoid errors such as failing to create symbolic links and clock skew detected from the make utility.

* VirtualBox 7.0
* Ubuntu 22.04 LTS (Jammy Jellyfish)
* Java 21
* Maven 3.9.7
* Python 3.11.9 and 3.12.3
* nvm 0.39.7 and Node 20.14.0 . The LTS version is Node 20.14.0 .
* Go 1.22.3
* VS Code 1.89.1
* Docker version 26.1.3, build b72abbb

2. This repository has been downloaded.

# Instructions

1. Navigate to the root directory `hello-virtualbox`.
```bash
cd hello-virtualbox

tree
Output:
.
├── LICENSE
├── output
│   └── default_download_dir.txt
├── README.md
├── run_setup.sh
└── script
    ├── run_step_apt.sh
    ├── run_step_docker.sh
    ├── run_step_git.sh
    ├── run_step_go.sh
    ├── run_step_java_maven.sh
    ├── run_step_java.sh
    ├── run_step_node.sh
    ├── run_step_python.sh
    ├── run_step_vscode.sh
    └── share_functions.sh
```

2. Run the script and complete the interactive setup wizard.
```bash
bash ./run_setup.sh
```

# Example `.desktop` File

```text
[Desktop Entry]
Type=Application
Exec=/path/to/executable
Icon=/path/to/icon
Name=Hello Application
```

# References

* [Amazon Corretto](https://aws.amazon.com/corretto/?filtered-posts.sort-by=item.additionalFields.createdDate&filtered-posts.sort-order=desc)
* [Apache Maven Download](https://maven.apache.org/download.cgi)
* [Python Developer's Guide, Setup and building](https://devguide.python.org/getting-started/setup-building/)
* [Configure Python](https://docs.python.org/3/using/configure.html)
* [nvm](https://github.com/nvm-sh/nvm)
* [Go, Download and install](https://go.dev/doc/install)
* [Managing Go installations](https://go.dev/doc/manage-install)
* [VS Code Updates](https://code.visualstudio.com/updates)
* [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)
* VS Code Extension Pack: [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
* [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* [Linux post-installation steps for Docker Engine](https://docs.docker.com/engine/install/linux-postinstall/)
