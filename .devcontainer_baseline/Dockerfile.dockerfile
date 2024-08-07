# Use the official Ubuntu 22.04 image as the base
# [dev_container_auto_added_stage_label  1/8]
FROM ubuntu:jammy
# Set environment variables to avoid interactive installation
ENV DEBIAN_FRONTEND noninteractive
# Set environment variables for TERRAFORM and PACKER
ENV TF_VERSION 1.9.0
ENV PACKER_VERSION 1.11.1
 

# [dev_container_auto_added_stage_label  2/8]
RUN apt-get update

# Install baseline packages
ENV base_packages="apt-transport-https gcc ca-certificates curl git gnupg jq krb5-user krb5-config libffi-dev libkrb5-dev libssl-dev lsb-release openssh-client sshpass unzip tzdata vim dos2unix"

# [dev_container_auto_added_stage_label  3/8]
RUN	apt-get install -y --no-install-recommends $base_packages \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean
 
# ENV pip_packages "ansible cryptography pywinrm kerberos requests_kerberos passlib msrest PyVmomi pymssql"

# RUN pip install --upgrade pip \
#     && pip install $pip_packages \
#     && pip install ansible[azure] \
#     && ansible-galaxy collection install azure.azcollection community.general \
#     && pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
 
# Terraform
# [dev_container_auto_added_stage_label  4/8]
RUN curl -O https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip -o terraform_${TF_VERSION}_linux_amd64.zip -d /usr/bin \
    && rm -f terraform_${TF_VERSION}_linux_amd64.zip \
    && chmod +x /usr/bin/terraform \

    && curl -O https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/bin \
    && rm -f packer_${PACKER_VERSION}_linux_amd64.zip \
    && chmod +x /usr/bin/packer

# Install Azure CLI 
# [dev_container_auto_added_stage_label  5/8]
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
 
# [dev_container_auto_added_stage_label  6/8]
# Powershell for Linux
RUN apt-get install -y wget software-properties-common \
    && . /etc/os-release \
    && wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# Terraform doc
# [dev_container_auto_added_stage_label  7/8]
RUN curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.17.0/terraform-docs-v0.17.0-$(uname)-amd64.tar.gz \
    && tar -xzf terraform-docs.tar.gz \
    && chmod +x terraform-docs

# Install tflint
# [dev_container_auto_added_stage_label  8/8]
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash    

# Instal other utilities
# ENV tools_packages="vim dos2unix"
# RUN apt-get install -y $tools_packages \
#     && rm -rf /var/lib/apt/lists/* \
#     && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
#     && apt-get clean

# # SQUID for GITHUB COPILOT 

# # Update package list and install Squid
# RUN apt-get update && apt-get install -y squid 
# # Copy custom Squid configuration file and restart squid service 
# COPY squid.conf /etc/squid/squid.conf
# RUN service squid restart
# # Expose the Squid port
# EXPOSE 3128
# # Run Squid in the foreground
# CMD ["squid", "-N"]

CMD    ["/bin/bash"]