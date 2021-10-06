# New Git Repo
Quickly create new GitHub repositories and attach them to a directory on your local computer.

## Dependencies
1. This is a bash script, per the shebang, and uses bash-specific syntax/features in certain places.
2. This script works best when you have Python3 installed. If for some crazy reason you don't, the script provides an option for you to manually go to github.com, create the repo yourself, then come back to the script.
3. The script uses [PyGithub](https://github.com/PyGithub/PyGithub) to create a GitHub repository via GitHub's API. `git-setup` attempts to install PyGithub if you don't have it already.

## Setup
1. Modify the script to somehow include a GitHub token and your GitHub username in the source code. Alternatively, create a bash environment variable for `GITHUB_USER` and `MASTER_GITHUB_TOKEN` containing your username and token, respectively.
2. Assuming you are on a Unix-like system, add the script to your path in some way (so you can run it from outside its storage directory). I just save the file in `/usr/local/bin`, which is already in my path.
3. Make the file executable by running `chmod u+x git-setup.sh` (so you can run it with `git-setup.sh <directory>` instead of `bash git-setup.sh <directory>`).
4. [Optional] Add `alias git-setup="git-setup.sh"` to `.bash_profile` so you can run the command as simply `git-setup <directory>`
