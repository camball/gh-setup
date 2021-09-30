#!/bin/bash
# create a new personal git repository and connect to GitHub

# check cmd line args; go to directory
if [ $# -eq 0 ]; then
    while true; do
        read -p "No path supplied... Would you like to use the current directory? [y/n]: " RESPONSE
        case $RESPONSE in
            [Yy]* ) cd $1 && break;;
            [Nn]* ) echo ""; echo "Usage: bash git-setup.sh <path-to-repo-directory>"; exit;;
            * ) echo "Please answer Y or N.";;
        esac
    done
else
    if [ ! -d "$1" ]; then
        mkdir $1 && cd $1
    fi
fi

# uncomment following lines to set up global environment
# git config --global init.defaultBranch main # in case git is still using "master" as default
# git config --global color.ui true
# git config --global user.name "camball"
# GITHUB_EMAIL=$(<githubemail.txt)
# git config --global user.email "$GITHUB_EMAIL"

read -p "Enter the title of the git repository: " REPO_NAME
echo ""

git init

echo "# $REPO_NAME" >> README.md
echo ".DS_Store" >> .gitignore

git add README.md .gitignore

git commit -m "First commit"
git branch -M main

echo ""
echo "Create a new GitHub repository at github.com/camball with title "$REPO_NAME". Press return when you have completed this step."
read

git remote add origin https://github.com/camball/$REPO_NAME.git
git push -u origin main

echo "" && echo "[Process Complete] Repo available at https://github.com/camball/$REPO_NAME"