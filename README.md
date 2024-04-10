# New Git Repo

Quickly create new GitHub repositories and attach them to a git-enabled directory on your local computer.

```sh
git-setup # set up current directory
git-setup path-to-directory-to-set-up/
```

## Install

1. Create a bash environment variable for `GITHUB_USER` and `MASTER_GITHUB_TOKEN` containing your username and token, respectively.
2. Run the make utility with `make`. Assuming you are on a Unix-like system, `make` adds the script to `/usr/local/bin`, which is likely already in your path. Doing this lets you run it from outside its storage directory.

## Dependencies

1. This script works best when you have Python3 installed. If for some crazy reason you don't, the script provides an option for you to manually go to github.com, create the repo yourself, then come back to the script.
2. The script uses [PyGithub](https://github.com/PyGithub/PyGithub) to create a GitHub repository via GitHub's API. `git-setup` attempts to install PyGithub if you don't have it already.
