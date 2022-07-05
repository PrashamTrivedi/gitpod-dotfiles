git config user.name $GITHUB_USER_NAME && git config user.email $GITHUB_USER_EMAIL




curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

source environments.sh