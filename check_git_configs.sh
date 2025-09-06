# identity
git config --show-origin --get user.name
git config --show-origin --get user.email

# line endings / permissions (WSL-friendly)
git config --show-origin --get core.autocrlf
git config --show-origin --get core.eol
git config --show-origin --get core.filemode
git config --show-origin --get core.ignorecase

# default branch name for new repos (optional)
git config --show-origin --get init.defaultBranch

# credentials (how push auth is handled)
git config --show-origin --get credential.helper

# safety (only if you’ve ever seen “detected dubious ownership in repository”)
git config --show-origin --get-regexp '^safe\.directory'

# repo-only settings
git config --local -l
cat .git/config

# your WSL user’s global settings
git config --global -l
cat ~/.gitconfig

# system-wide (might require sudo; ok if it says permission denied)
sudo git config --system -l 2>/dev/null || echo "no system config access (normal on WSL)"
