#!/bin/bash

set -e

add_courtesy_reminder() {
    echo
    echo !!! ATTENTION !!! IMPORTANT !!!
    echo If you installed Node, exit this non-login session and start a new session

    echo
    echo !!! ATTENTION !!! IMPORTANT !!!
    echo If you installed Docker, reboot. Then, confirm the installation by running the command below
    echo docker run hello-world
}

main() {
    script/run_step_apt.sh
    script/run_step_git.sh
    script/run_step_java.sh
    script/run_step_java_maven.sh
    script/run_step_python.sh
    script/run_step_node.sh
    script/run_step_vscode.sh
    script/run_step_docker.sh
    add_courtesy_reminder
}

((
main
) 2>&1) | tee $(pwd)/output/run-setup.log