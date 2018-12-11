# Infrastructure-as-Code TestKit for Ubuntu
#
# VERSION: 18.04

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

COPY requirements.txt requirements.txt

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update -qq &&\
    apt-get install -qq --no-install-recommends \
        apt-transport-https \
        apt-utils \
        aptitude \
        awscli \
        ca-certificates \
        curl \
        gpg \
        gpg-agent \
        gzip \
        jq \
        python-pip \
        software-properties-common \
        unzip \
        wget &&\
    wget -q -O - https://download.docker.com/linux/ubuntu/gpg | apt-key add - &&\
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list &&\
    apt-get update -qq &&\
    apt-get install -qq --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        docker-compose &&\
    aptitude full-upgrade -y -q &&\
    apt-get autoremove -qq &&\
    aptitude autoclean -y -q &&\
    apt-get clean -qq &&\
    rm -rf /var/lib/apt/lists/* &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/timezone &&\
    pip install --upgrade -qqq -r requirements.txt &&\
    wget -q -O terraform.zip https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip &&\
    unzip -o -qq terraform.zip -d /usr/bin/ &&\
    wget -q -O packer.zip https://releases.hashicorp.com/packer/1.3.2/packer_1.3.2_linux_amd64.zip &&\
    unzip -o -qq packer.zip -d /usr/bin/ &&\
    wget -q -O vault.zip https://releases.hashicorp.com/vault/1.0.0/vault_1.0.0_linux_amd64.zip &&\
    unzip -o -qq vault.zip -d /usr/bin/ &&\
    wget -q -O consul.zip https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip &&\
    unzip -o -qq consul.zip -d /usr/bin/ &&\
    wget -q -O /usr/bin/terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v0.13.13/terratest_log_parser_linux_amd64

ENTRYPOINT [ "/bin/bash", "-c" ]
