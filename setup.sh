#!/bin/sh
curl -L "https://github.com/PrashamTrivedi/gitconfig-provider/releases/download/1.21/gitconfig-provider_1.21_Linux_x86_64.tar.gz" -o "gitconfig-provider.tar.gz"
tar -xvf gitconfig-provider.tar.gz
chmod +x gitconfig-provider
$PATH="gitconfig-provider:$PATH"


gitconfig-provider addConfig -provider=Github -key=user.email -value=$GITHUB_USER_EMAIL
gitconfig-provider addConfig -provider=Github -key=user.name -value=$GITHUB_USER_NAME


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

. ~/.dotfiles/environments.sh

echo $AWS_DEFAULT_REGION
# eval $(gp env PATH="$HOME/gitconfig-provider:$PATH")
# eval $(gp env AWS_ACCESS_KEY_ID=$AWS_PERSONAL_ACCESS_KEY_ID)
# eval $(gp env AWS_SECRET_ACCESS_KEY=$AWS_PERSONAL_SECRET_ACCESS_KEY)
# eval $(gp env AWS_DEFAULT_REGION=ap-south-1)