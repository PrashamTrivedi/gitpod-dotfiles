#!/bin/sh

# Install Gitconfig Provider
echo CurrentDir is
echo $(pwd) 

curl -L "https://github.com/PrashamTrivedi/gitconfig-provider/releases/download/1.22/gitconfig-provider_1.22_Linux_x86_64.tar.gz" -o "gitconfig-provider.tar.gz"
tar -xvf gitconfig-provider.tar.gz
chmod +x gitconfig-provider

echo CurrentDir is
echo $(pwd) 

# Copy gitconfit provider bashrc
chmod +x ~/.dotfiles/gitconfig-provider-bashrc
cp ~/.dotfiles/gitconfig-provider-bashrc ~/.bashrc.d/gitconfig-provider-bashrc


# Install and verify AWS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
aws --version

# Copy aws to Bashrc
chmod +x ~/.dotfiles/aws
cp ~/.dotfiles/aws ~/.bashrc.d/aws

# Copy git-alias to Bashrc
chmod +x ~/.dotfiles/git-alias
cp ~/.dotfiles/git-alias ~/.bashrc.d/git-alias

echo $(pwd)

# Apply Gitconfig provider for github
~/gitconfig-provider addConfig -provider=Github -key=user.email -value=$GITHUB_USER_EMAIL
~/gitconfig-provider addConfig -provider=Github -key=user.name -value=$GITHUB_USER_NAME
