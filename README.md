# New GitHub Repo

Quickly create new GitHub repositories and attach them to a git-enabled directory on your local computer.

```sh
gh-setup # set up current directory
gh-setup path-to-directory-to-set-up/
```

## Install

1. [Create a fine-grained access token](https://github.com/settings/personal-access-tokens/new) with "Public Repositories (read-only)" repository access (it doesn't need access to any private info). Copy the token and export it as the `GITHUB_TOKEN` environment variable on shell startup (in your `.zshrc`, `.bashrc`, etc.)

    ```sh
    echo "export GITHUB_TOKEN=<your_github_token>" >> ~/.zshrc
    ```

2. Build with `make` to place the command on your path (in `/usr/local/bin`)

    ```sh
    make
    ```

## Dependencies

1. This script works best when you have Python3 installed. If you don't, the script provides an option for you to manually go to GitHub and create the repo yourself, then come back to the script, yet this essentially defeats the convenience of this script.
2. The script uses [PyGithub](https://github.com/PyGithub/PyGithub) to create a GitHub repository via GitHub's API. `gh-setup` attempts to install PyGithub if you don't have it already.
