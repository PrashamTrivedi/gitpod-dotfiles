#!/bin/sh

# Install Gitconfig Provider


curl -L "https://github.com/PrashamTrivedi/gitconfig-provider/releases/latest/download/gitconfig-provider_Linux_x86_64.tar.gz" -o "gitconfig-provider.tar.gz"
tar -xvf gitconfig-provider.tar.gz
chmod +x gitconfig-provider

# Copy gitconfit provider bashrc
chmod +x gitconfig-provider-bashrc
cp gitconfig-provider-bashrc ~/.bashrc.d/gitconfig-provider-bashrc


# Install and verify AWS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
aws --version

# Copy aws to Bashrc
chmod +x awsConfig
cp awsConfig ~/.bashrc.d/awsConfig

# Copy git-alias to Bashrc
chmod +x git-alias
cp git-alias ~/.bashrc.d/git-alias


# Apply Gitconfig provider for github
~/gitconfig-provider addConfig --provider=Github --key=user.email --value=$GITHUB_USER_EMAIL
~/gitconfig-provider addConfig --provider=Github --key=user.name --value=$GITHUB_USER_NAME
