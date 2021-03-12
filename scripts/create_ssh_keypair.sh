#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# create_ssh_keypair.sh
#
# Create an SSH key
#
# Usage: bash create_ssh_keypair.sh
# 
#   Overwrite an existing keypair:
#       bash create_ssh_keypair.sh -f
#
# Author: Jayson Grace, https://techvomit.net
# ----------------------------------------------------------------------------
# Stop execution of script if an error occurs
set -e

CONTROL_NODE_FILES='control/files'
KEY_NAME='ansible_dev_env'
MANAGED_UBUNTU_FILES='managed-ubuntu/files'
MANAGED_CENTOS_FILES='managed-centos/files'
# Color Output
BLUE="\033[01;34m"
GREEN="\033[01;32m" 
RED="\033[01;31m"
YELLOW='\033[0;33m'   
RESET="\033[00m"
# CLI arg
FORCE=false

# Check if CLI arg specified
while getopts ':f' option; do
    case "${option}" in
        'f') FORCE=true ;;
    esac
done
shift $(( OPTIND - 1 ))

existing_keypair() {
    if [[ $FORCE = true ]]; then
        echo -e "${RED}Force (-f) specified, overwriting any existing ssh keypairs and associated files!${RESET}"
        return 0
    fi

    if [[ -f "${CONTROL_NODE_FILES}/authorized_keys" ]] || \
       [[ -f "${MANAGED_NODE_FILES}/authorized_keys" ]] || \
       [[ -f "${MANAGED_NODE_FILES}/${KEY_NAME}" ]] || \
       [[ -f "${MANAGED_NODE_FILES}/${KEY_NAME}.pub" ]] || \
       [[ -f "${CONTROL_NODE_FILES}/${KEY_NAME}" ]] || \
       [[ -f "${CONTROL_NODE_FILES}/${KEY_NAME}.pub" ]]; then
            echo -e "${YELLOW}Found existing SSH keypair, skipping the keypair generation step.${RESET}"
            return 1
    else
        return 0
    fi
}

gen_keypair() {
    echo -e "${GREEN}Creating SSH keypair ${KEY_NAME}.${RESET}" 
    ssh-keygen -t rsa -m PEM -C "Ansible Control Node Key" -f "${KEY_NAME}" -N ''
}

ssh_files() {
    echo -e "${YELLOW}Adding ${KEY_NAME}.pub to managed nodes authorized_keys.${RESET}"
    cp "${KEY_NAME}.pub" "${MANAGED_UBUNTU_FILES}/ssh/authorized_keys"
    cp "${KEY_NAME}.pub" "${MANAGED_CENTOS_FILES}/ssh/authorized_keys"

    echo -e "${YELLOW}Moving ${KEY_NAME} private key to ${CONTROL_NODE_FILES}/ssh.${RESET}"
    mv "${KEY_NAME}" "${CONTROL_NODE_FILES}/ssh"
}

ssh_config() {
    cat > config <<- EOM
Host *
  User ansible
  IdentityFile /home/ansible/.ssh/$KEY_NAME
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
EOM
    mv config "${CONTROL_NODE_FILES}/ssh"
}

main(){
    if existing_keypair == false; then
        gen_keypair
        ssh_files
        ssh_config
    fi
}

main