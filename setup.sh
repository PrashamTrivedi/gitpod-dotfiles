curl "https://github.com/PrashamTrivedi/gitconfig-provider/releases/download/1.21/gitconfig-provider_1.21_Linux_arm64.tar.gz" -o "gitconfig-provider.tar.gz"
tar -xvf gitconfig-provider.tar.gz

gitconfig-provider addConfig -provider=Github -key=user.email -value=$GITHUB_USER_EMAIL
gitconfig-provider addConfig -provider=Github -key=user.name -value=$GITHUB_USER_NAME

alias gitpull="git stash && git pull && git stash pop"
alias gitpush="git push && git push --tags && git stash clear"

export AWS_ACCESS_KEY_ID=$AWS_PERSONAL_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_PERSONAL_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=ap-south-1

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
