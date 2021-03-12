FROM ubuntu:20.04

LABEL Maintainer="Jayson Grace <https://techvomit.net>"

RUN apt-get update && \
    apt-get install -y \
    ssh \
    sudo && \
    # Create ansible user
    useradd -ms /bin/bash ansible && \
    # Add it to the sudoers file
    echo 'ansible 	ALL=(ALL)	NOPASSWD: ALL' >> /etc/sudoers

COPY files/ssh /home/ansible/.ssh

RUN chown -R ansible:ansible /home/ansible && \
    chmod 700 /home/ansible/.ssh/ && \
    chmod 644 /home/ansible/.ssh/authorized_keys && \
    mkdir /var/run/sshd && \
    rm -rf /var/lib/apt/lists/*

USER ansible
WORKDIR /home/ansible

EXPOSE 22

CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]