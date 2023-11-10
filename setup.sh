#!/bin/sh

# Install Gitconfig Provider


# First cd into root folder
cd ~
curl -L "https://github.com/PrashamTrivedi/gitconfig-provider/releases/latest/download/gitconfig-provider_Linux_x86_64.tar.gz" -o "gitconfig-provider.tar.gz"
mkdir -p ~/gitconfig-provider
tar -xvf gitconfig-provider.tar.gz -C ~/gitconfig-provider
chmod +x ~/gitconfig-provider/gitconfig-provider
sudo ln -s ~/gitconfig-provider/gitconfig-provider /usr/bin/gitconfig-provider

curl -L "https://github.com/PrashamTrivedi/assistants-cli/releases/latest/download/assistants-cli_Linux_x86_64.tar.gz" -o "assistants-cli.tar.gz"
mkdir -p ~/assistant-cli
tar -xvf assistants-cli.tar.gz -C ~/assistant-cli
chmod +x ~/assistant-cli/assistants-cli
sudo ln -s ~/assistant-cli/assistants-cli /usr/bin/assistant-cli


# Install and verify AWS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
aws --version
sudo ln -s /usr/local/aws-cli/v2/current/bin/aws /usr/bin/aws

# Copy aws to Bashrc
chmod +x awsConfig
cp awsConfig ~/.bashrc.d/awsConfig

# Copy git-alias to Bashrc
chmod +x git-alias
cp git-alias ~/.bashrc.d/git-alias


# Apply Gitconfig provider for github
~/gitconfig-provider addConfig --provider=Github --key=user.email --value=$GITHUB_USER_EMAIL
~/gitconfig-provider addConfig --provider=Github --key=user.name --value=$GITHUB_USER_NAME

pip install aider-chat llm sgpt