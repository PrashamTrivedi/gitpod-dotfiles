#!/bin/sh
export PATH="$HOME/gitconfig-provider:$PATH"
export AWS_ACCESS_KEY_ID=$AWS_PERSONAL_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_PERSONAL_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=ap-south-1
alias gitpull="git stash && git pull && git stash pop"
alias gitpush="git push && git push --tags && git stash clear"
ZSH_THEME="agnoster"