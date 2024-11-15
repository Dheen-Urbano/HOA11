FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y mysql-server ansible nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY playbook.yml /etc/ansible/playbook.yml
COPY inventory /etc/ansible/inventory

WORKDIR /etc/ansible

EXPOSE 80 3306

CMD service mysql start && \
    while ! mysqladmin ping -h "127.0.0.1" --silent; do \
        sleep 1; \
    done && \
    ansible-playbook -i inventory playbook.yml && \
    nginx -g 'daemon off;'
