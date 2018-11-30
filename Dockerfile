# Infrastructure-as-Code TestKit for Ubuntu
#
# VERSION: 18.04

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
COPY requirements.txt requirements.txt
# hadolint ignore=DL3008
RUN apt-get update -qq &&\
    apt-get install -qq --no-install-recommends aptitude apt-utils &&\
    aptitude full-upgrade -y -q &&\
    aptitude install -y -q python-pip python3-pip wget jq awscli gzip unzip &&\
    apt-get autoremove -qq &&\
    aptitude autoclean -y -q &&\
    apt-get clean -qq &&\
    rm -rf /var/lib/apt/lists/* &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/timezone &&\
    pip3 install --upgrade -qqq -r requirements.txt &&\
    pip install --upgrade -qqq -r requirements.txt &&\
    wget -q -O terraform.zip https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip &&\
    unzip -o -qq terraform.zip -d /usr/bin/ &&\
    wget -q -O packer.zip https://releases.hashicorp.com/packer/1.3.2/packer_1.3.2_linux_amd64.zip &&\
    unzip -o -qq packer.zip -d /usr/bin/ &&\
    wget -q -O /usr/bin/terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v0.13.13/terratest_log_parser_linux_amd64

ENTRYPOINT [ "/bin/bash", "-c" ]
