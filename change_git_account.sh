#!/bin/bash

# Function to configure SSH and Git for a given account
configure_git_account() {
    local account_name=$1
    local email=$2
    local username=$3
    local ssh_config=$4

    echo "Configuring Git for account: $account_name"

    # Set global Git configurations
    git config --global user.name "$username"
    git config --global user.email "$email"

    # Update SSH config
    if ! grep -q "$ssh_config" ~/.ssh/config 2>/dev/null; then
        echo "$ssh_config" >> ~/.ssh/config
        echo "Added $account_name SSH configuration to ~/.ssh/config."
    else
        echo "$account_name SSH configuration already exists in ~/.ssh/config."
    fi

    # Restart the SSH agent to ensure changes take effect
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/$(echo "$ssh_config" | grep -o 'id_[^ ]*')

    echo "Git and SSH are now configured for $account_name."
}

# SSH configurations for each account
ssh_config_personal="Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519"

ssh_config_work="Host github.com-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_home_github"

# Account details
email_personal="prashant@mande.network"
username_personal="p-mande"
email_work="prashanttechjha@gmail.com"
username_work="p-bucky"

# Choose an account to configure
echo "Select the GitHub account to configure:"
echo "1. Personal Account (p-mande)"
echo "2. Work Account (p-bucky)"
read -p "Enter the number (1 or 2): " choice

case $choice in
    1)
        configure_git_account "Personal Account" "$email_personal" "$username_personal" "$ssh_config_personal"
        ;;
    2)
        configure_git_account "Work Account" "$email_work" "$username_work" "$ssh_config_work"
        ;;
    *)
        echo "Invalid choice. Please select 1 or 2."
        ;;
esac
