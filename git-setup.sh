#!/bin/bash
# create a new personal git repository and connect to GitHub
# by Cameron Ball, October 2021

GITHUB_USERNAME="$GITHUB_USER"
GITHUB_TOKEN="$MASTER_GITHUB_TOKEN"

# uncomment following lines to set up global environment
# git config --global init.defaultBranch main # in case git is still using "master" as default
# git config --global color.ui true
# git config --global user.name "$GITHUB_USERNAME"
# git config --global user.email "your_github_email"

# check cmd line args; go to directory
if [ $# -eq 0 ]; then
    while true; do
        read -p "No path supplied... Would you like to use the current directory? [y/n]: " RESPONSE
        case $RESPONSE in
            [Yy]* ) break;;
            [Nn]* ) echo ""; echo "Usage: bash git-setup.sh <path-to-repo-directory>"; exit;;
            * ) echo "Please answer Y or N.";;
        esac
    done

    # set 
    while true; do
        read -p "Use current directory title as title of GitHub repository? [y/n]: " RESPONSE
        case $RESPONSE in
            [Yy]* ) REPO_NAME=$(basename $PWD); break;;
            [Nn]* ) echo ""; read -p "Enter the title of the git/GitHub repository: " REPO_NAME; break;;
            * ) echo "Please answer Y or N.";;
        esac
    done
else
    if [ ! -d "$1" ]; then
        mkdir $1 && cd $1
    else
        cd $1
    fi
    
    TEMP=$(basename $1)
    while true; do
        read -p "Use $TEMP as title of GitHub repository? [y/n]: " RESPONSE
        case $RESPONSE in
            [Yy]* ) REPO_NAME="$TEMP"; break;;
            [Nn]* ) echo ""; read -p "Enter the title of the git/GitHub repository: " REPO_NAME; break;;
            * ) echo "Please answer Y or N.";;
        esac
    done
fi

echo ""
git init
echo ""

echo "# $REPO_NAME" >> README.md

# .gitignores from https://github.com/github/gitignore
case "$OSTYPE" in
    darwin*) echo "# General
.DS_Store
.AppleDouble
.LSOverride

Icon[\r]

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk" >> .gitignore;; 
    linux*) echo "*~

# temporary files which can be created if a process still has a handle open of a deleted file
.fuse_hidden*

# KDE directory preferences
.directory

# Linux trash folder which might appear on any partition or disk
.Trash-*

# .nfs files are created when an open file is removed but is still being accessed
.nfs*" >> .gitignore;;
    msys|cygwin*) echo "# Windows thumbnail cache files
Thumbs.db
Thumbs.db:encryptable
ehthumbs.db
ehthumbs_vista.db

# Dump file
*.stackdump

# Folder config file
[Dd]esktop.ini

# Recycle Bin used on file shares
$RECYCLE.BIN/

# Windows Installer files
*.cab
*.msi
*.msix
*.msm
*.msp

# Windows shortcuts
*.lnk" >> .gitignore;;
    *) echo ".gitignore not created: UNKNOWN: $OSTYPE";;
esac

git add README.md .gitignore

git commit -m "First commit"
git branch -M main

# create GitHub repository
if [[ $(python3 --version) != "Python 3."* ]]; then
    # if Python3 not installed, user can perform manual Github repository creation.
    while true; do
        echo "Dependency \"Python3\" not installed..."
        read -p "Would you like to manually create the GitHub repository? [y/n]: " RESPONSE
        case $RESPONSE in
            [Yy]* ) 
                echo ""
                echo "Create a new GitHub repository at github.com/$GITHUB_USERNAME with title "$REPO_NAME". Press return when you have completed this step."
                read; break;;
            [Nn]* ) echo ""; echo "Exiting..."; exit;;
            * ) echo "Please answer Y or N.";;
        esac
    done

else # Python3 is available, so pip3 is also available
    # make sure module PyGithub is installed
    if [ $(pip3 list | grep -o "PyGithub") = "PyGithub" ]; then
        :
    else
        echo "Dependency \`PyGithub\` not installed: attempting to install with pip3..."
        pip3 install PyGithub
        echo ""
    fi
    
    # Create GitHub repo using PyGithub
    python3 -c "from github import Github
g = Github('$GITHUB_TOKEN')
user = g.get_user()
repo = user.create_repo('$REPO_NAME')
quit()" # sorry for weird indentation - can't run python with bash's indentation
    # TODO: implement error handling if repository couldn't be created for some reason
fi

git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
git push -u origin main

echo "" && echo "[Process Complete] Repo available at https://github.com/$GITHUB_USERNAME/$REPO_NAME"
