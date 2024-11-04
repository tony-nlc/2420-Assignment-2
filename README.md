# 2420-Assignment-2

## Introduction

This repository contains two Bash scripts for automating system administration tasks. These tasks are designed to help users automate system setup and user management in a Unix environment. Both scripts follow Bash best practices and include error handling, detailed comments, and command-line options.

Project Structure

1. System Setup Scripts: Automating system setup by installing packages and linking configuration files.

2. User Creation Script: Automating user creation, including setting up the user’s environment and permissions.

---

## Project 1

The **System Setup Scripts** automate essential system setup tasks for a new or freshly installed system.

The script we are creating will includes the following two actions:

-   Software Installation
-   Symbolic Linking of Configuration Files

This script will help us quickly configure a new system environment by pulling configurations from a Git repository and installing essential packages.

-   Tmux https://wiki.archlinux.org/title/Tmux
-   Kakoune https://wiki.archlinux.org/title/Kakoune

https://docs.gitlab.com/ee/topics/git/clone.html

**Script 1.1: Cloning Configuration & Installing Packages**

```bash
#!/bin/bash
# Filename: setup
# Description: Intialize Git and download user-defined packages

# Step 1: Clone the configuration files
git init # Initialize a git repository
git clone https://gitlab.com/cit2420/2420-as2-starting-files main # Git clone the setup repository

# Step 2: Install the dependency and install packages
sudo pacman -S kakoune tmux unzip # Install two packages as user-defined
```

**Script 1.2: Making Symbloic Links**

```bash
#!/bin/bash
# Filename: link
# Description: Link config files and bin files to our bin and .config

# Error Handling Function
mkdir_handle() {
  local dir_name=$1 # Initialize a local variable for storing the directory we are checking
  if ! [[ -d $dir_name ]]; then # Check if the directory does not exist
    mkdir $dir_name # Create a directory with the name provided
  fi
}

# Step 1: Creating Symbolic Link For ~/bin/* and ~/main/bin/*
mkdir_handle ~/bin # Check if ~/bin exist if not create ~/bin

for file in ~/main/bin/*; do # Loop over the file in the git repository's /bin
  ln -s "$file" ~/bin/$(basename "$file") # Link our ~/bin/<filename> to the file in git repostiroy's /bin/<filename>
done

# Step 2: Creating Symbolic Link for ~/.config/*/* and ~/main/config/*/*
mkdir_handle ~/.config # Check if ~/.config exist if not create ~/config

for dir in ~/config/*; do # Loop over the directory under git repository's /config
  subdir_name=$(basename "$dir") # Convert the directory path to its basename
  if ! [[ -d "~/.config/$dir" ]]; then # Check if directory already exist or not
    mkdir_handle "$HOME/.config/$subdir_name" # Create a subdirectory under .config with the application's name
  fi
    for file in "$dir"/*; do # Loop over the file under Git repository's /config/<applicatiob>/name
      ln -s "$file" "~/.config/$subdir_name/$(basename "$file")" # Link our ~/.config/<application>/<application's config> to the file in git repostiroy's /config/<application>/<config>
    done
  fi
done

```

**Script 1.3: Activate Script**

```bash
#!/bin/bash
# Filename: main
# Description: Run setup.sh and link.sh

./setup # Run the setup script
./link # Run the link script
```

Afterwards, you need to give your main the permission to execute. You can use the following line of command to grant execute permission to user.

```bash
sudo chmod u+x ./main
```
---
