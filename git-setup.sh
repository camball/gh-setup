#!/bin/bash
# create a new personal git repository and connect to GitHub

GITHUB_USERNAME="$GITHUB_USER"
GITHUB_TOKEN="$MASTER_GITHUB_TOKEN"

# if either variable is unavailable, abort script and notify user
if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Exiting: GitHub credentials not found. Please ensure this script has \
access to credentials in some way (by default, by setting \$GITHUB_USER and \
\$MASTER_GITHUB_TOKEN environment variables in your shell's startup script \
(i.e., .zshrc, .bashrc, etc.)"; exit;
fi

# paste following lines in your terminal to set up your global git environment
# git config --global init.defaultBranch main # in case git is still using "master" as default
# git config --global color.ui true
# git config --global user.name "your_github_username"
# git config --global user.email "your_github_email"

# check cmd line args; go to directory
if [ $# -eq 0 ]; then
    while true; do
        read -p "No path supplied... Would you like to use the current directory? [y/n]: " RESPONSE
        case $RESPONSE in
            [Yy]* ) break;;
            [Nn]* ) echo ""; echo "Usage: git-setup.sh <path-to-repo-directory>"; exit;;
            * ) echo "Please answer Y or N.";;
        esac
    done

    # set title of GitHub repo
    while true; do
        read -p "Use current directory title as title of GitHub repository? [y/n]: " RESPONSE
        case $RESPONSE in
            [Yy]* ) USER_REPO_NAME=$(basename "$PWD"); break;;
            [Nn]* ) echo ""; read -p "Enter the title of the git/GitHub repository: " USER_REPO_NAME; break;;
            * ) echo "Please answer Y or N.";;
        esac
    done
else
    if [ ! -d "$1" ]; then
        mkdir $1 && cd $1
    else
        cd $1
    fi
    
    DIR_TITLE_FROM_SUPPLIED_PATH=$(basename "$1")
    while true; do
        read -p "Use $DIR_TITLE_FROM_SUPPLIED_PATH as title of GitHub repository? [y/n]: " RESPONSE
        case $RESPONSE in
            [Yy]* ) USER_REPO_NAME="$DIR_TITLE_FROM_SUPPLIED_PATH"; break;;
            [Nn]* ) echo ""; read -p "Enter the title of the git/GitHub repository: " USER_REPO_NAME; break;;
            * ) echo "Please answer Y or N.";;
        esac
    done
fi

REPO_MANUALLY_CREATED=false

manuallyCreateRepo () {
    REPO_MANUALLY_CREATED=true
    while true; do
        read -p "Would you like to manually create the GitHub repository? [y/n]: " RESPONSE
        case $RESPONSE in
            [Yy]* ) 
                echo ""
                echo "Create a new GitHub repository at github.com/$GITHUB_USERNAME with title "$USER_REPO_NAME". Press return when you have completed this step."
                read; break;;
            [Nn]* ) echo ""; echo "Exiting..."; exit;;
            * ) echo "Please answer Y or N.";;
        esac
    done
}

# create GitHub repository
if [[ $(python3 --version) != "Python 3."* ]]; then
    # if Python3 not installed, user can perform manual Github repository creation.
    echo "Dependency \"Python3\" not installed..."
    manuallyCreateRepo

else # Python3 is available, so pip3 is also available
    # Even though Python3 is available, check if version is compatible with PyGithub
    if (( $(echo "$(python3 --version | cut -c 10-) < 6" | bc -l) )); then
        # version requirements per https://pypi.org/project/PyGithub/ on 12/10/21
        echo "Python version $(python3 --version | cut -c 8-) is incompatible with PyGithub. Please use Python 3.6 or above to utilize PyGithub functionality."
        manuallyCreateRepo
    else
        # make sure module PyGithub is installed
        if [ "$(pip3 list | grep -o "PyGithub")" != "PyGithub" ]; then
            echo "Dependency \`PyGithub\` not installed: attempting to install with pip3..."
            pip3 install PyGithub
            echo ""

            if [ "$(pip3 list | grep -o "PyGithub")" != "PyGithub" ]; then
                echo "Dependency \`PyGithub\` could not be installed..."
                manuallyCreateRepo
            fi
        fi

        if [ "$REPO_MANUALLY_CREATED" = false ]; then
            # Create GitHub repo using PyGithub
            RETURNED_REPO_NAME=$(python3 -c "from github import Github
import sys
g = Github('$GITHUB_TOKEN')
user = g.get_user()
repo = user.create_repo('$USER_REPO_NAME')
sys.exit(repo.name)" 2>&1 > /dev/null) # weird indentation is to run python properly

            # here would be the place to check if the return status of the
            # python script returned 0, indicating a successful repository
            # creation. But, because we need to capture the name of the repo,
            # we assume the repository was created successfully. An unfortunate
            # tradeoff.
        fi
    fi
fi

# if the repository was manually created, we need to get the name of the actual
# repository, which may be different from what the user entered, because of how
# GitHub replaces characters (i.e., spaces for dashes). This is done for us
# when the repository is created for us, as we already have a link to the repo.
# The way we do this isn't perfect, but works most of the time. We search for
# the name of the repository from the user's repositories and return the result
if [ "$REPO_MANUALLY_CREATED" = true ]; then
    RETURNED_REPO_NAME=$(python3 -c "from github import Github
import sys
g = Github('$GITHUB_TOKEN')
repos = g.search_repositories(query='$USER_REPO_NAME in:name user:$GITHUB_USERNAME')
for repo in repos:
    sys.exit(repo.name)" 2>&1 > /dev/null) # weird indentation is to run python properly
fi

# create git repository, README.md, and .gitignore
echo ""
git init
echo ""

echo "# $RETURNED_REPO_NAME" >> README.md

GITIGNORE_CREATED=true
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
    *) echo ".gitignore not created: UNKNOWN: $OSTYPE"; GITIGNORE_CREATED=false;;
esac

if [ "$GITIGNORE_CREATED" = false ]; then
    git add README.md
else
    git add README.md .gitignore
fi

# link local git repository to created GitHub repository and push initial files
git commit -m "First commit (auto-generated by \`git-setup.sh\` with <3)"
git branch -M main

git remote add origin https://github.com/$GITHUB_USERNAME/$RETURNED_REPO_NAME.git
git push -u origin main

echo "" && echo "[Process Complete] Repo available at https://github.com/$GITHUB_USERNAME/$RETURNED_REPO_NAME"
