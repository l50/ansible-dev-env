# ansible-dev-env
[![License](http://img.shields.io/:license-mit-blue.svg)](https://github.com/l50/ansible_dev_env/blob/main/LICENSE)

Simple development lab for Ansible with a single managed node.

## Dependencies
You must download and install the following for this environment to work:
* [Docker](https://docs.docker.com/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)

## Building the environment
To create an environment with an ansible control node that manages a single node, run the following command:
```
make build
```

To tear down the lab and delete all SSH artifacts, run the following command:
```
make destroy
```

## Getting Started
```
docker exec -it control_node bash
cd /etc/ansible
# Run the hello role on the managed node
ansible-playbook -vvv site.yml
```

## Misc
- Everything in `/etc/ansible` on the control node is persisted across builds via a docker volume, so don't worry about losing things if your container dies.
- If you want to generate a new SSH keypair without destroying and rebuilding the environment, run `scripts/create_ssh_keypair.sh` with a `-f` flag