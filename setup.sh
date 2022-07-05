git config user.name $GITHUB_USER_NAME && git config user.email $GITHUB_USER_EMAIL
alias gitpull="git stash && git pull && git stash pop"
alias gitpush="git push && git push --tags && git stash clear"

export AWS_ACCESS_KEY_ID=$AWS_PERSONAL_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_PERSONAL_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=ap-south-1

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
