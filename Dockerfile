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
        gpg \
        gpg-agent \
        software-properties-common \
        wget &&\
    wget -q -O - https://download.docker.com/linux/ubuntu/gpg | apt-key add - &&\
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list &&\
    apt-get update -qq &&\
    apt-get install -qq --no-install-recommends \
        awscli \
        build-essential \
        python3-dev \
        python3-pip \
        python3-psutil \
        python3-setuptools \
        python3-wheel \
        docker-ce \
        docker-compose \
        unzip &&\
    aptitude full-upgrade -y -q &&\
    apt-get autoremove -qq &&\
    apt-get clean -qq &&\
    aptitude autoclean -y -q &&\
    rm -rf /var/lib/apt/lists/* &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/timezone &&\
    pip3 install --upgrade -r requirements.txt &&\
    wget -q -O terraform.zip https://releases.hashicorp.com/terraform/0.12.11/terraform_0.12.11_linux_amd64.zip &&\
    unzip -o -qq terraform.zip -d /usr/bin/ &&\
    wget -q -O packer.zip https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip &&\
    unzip -o -qq packer.zip -d /usr/bin/ &&\
    wget -q -O vault.zip https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip &&\
    unzip -o -qq vault.zip -d /usr/bin/ &&\
    wget -q -O consul.zip https://releases.hashicorp.com/consul/1.6.1/consul_1.6.1_linux_amd64.zip &&\
    unzip -o -qq consul.zip -d /usr/bin/ &&\
    wget -q -O /usr/bin/terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v0.21.0/terratest_log_parser_linux_amd64

ENTRYPOINT [ "/bin/bash", "-c" ]
