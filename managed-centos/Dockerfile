FROM centos:8

LABEL Maintainer="Jayson Grace <https://techvomit.net>"

RUN dnf update -y && \
    dnf install -y \
    openssh-server \
    sudo && \
    # Create ansible user
    useradd -ms /bin/bash ansible && \
    # Add it to the sudoers file
    echo 'ansible 	ALL=(ALL)	NOPASSWD: ALL' >> /etc/sudoers && \
    yum -y clean all

COPY files/ssh /home/ansible/.ssh

RUN chown -R ansible:ansible /home/ansible && \
    chmod 700 /home/ansible/.ssh/ && \
    chmod 644 /home/ansible/.ssh/authorized_keys && \
    # Add missing files needed by the ssh server
    test -f /etc/ssh/ssh_host_ecdsa_key || /usr/bin/ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N '' && \
    test -f /etc/ssh/ssh_host_rsa_key || /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N '' && \
    test -f /etc/ssh/ssh_host_ed25519_key || /usr/bin/ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N '' && \
    # Fix annoying error about the host still booting up
    rm -rf /run/nologin

USER ansible
WORKDIR /home/ansible

EXPOSE 22

CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]
