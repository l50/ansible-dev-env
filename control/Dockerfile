FROM ubuntu:20.04

LABEL Maintainer="Jayson Grace <https://techvomit.net>"

RUN apt-get update && \
    apt-get install -y ansible curl iproute2 ssh vim wget && \
    # Create ansible user
    useradd -ms /bin/bash ansible

COPY files/ssh /home/ansible/.ssh

RUN chown -R ansible:ansible /home/ansible && \
    chown -R ansible:ansible /etc/ansible && \
    chmod 700 /home/ansible/.ssh && \
    chmod 600 /home/ansible/.ssh/config /home/ansible/.ssh/ansible_dev_env && \
    rm -rf /var/lib/apt/lists/*

USER ansible
WORKDIR /etc/ansible

EXPOSE 22

CMD ["/sbin/init"]
