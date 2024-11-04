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

https://docs.gitlab.com/ee/topics/git/clone.html
https://wiki.archlinux.org/title/Tmux
https://wiki.archlinux.org/title/Kakoune

**Script 1.1: Cloning Configuration & Installing Packages**

```bash
#!/bin/bash
# Step 1: Clone the configuration files
git init # Initialize a git repository
git clone https://gitlab.com/cit2420/2420-as2-starting-files main # Git clone the setup repository

# Step 2: Install the dependency and install packages
sudo pacman -S kakoune tmux unzip # Install two packages as user-defined
```

**Script 1.2: Making Symbloic Links**

```bash
#!/bin/bash
# Error Handling Function
mkdir_handle() {
  local dir_name=$1
  if ! [[ -d $dir_name ]]; then
    mkdir $dir_name
  fi
}
# Step 1: Creating Symbolic Link For ~/bin/* and ~/main/bin/*
mkdir_handle ~/bin # Check if ~/bin exist if not create ~/bin

for file in ~/main/bin/*; do
  ln -s "$file" ~/bin/$(basename "$file")
done

# Step 2: Creating Symbolic Link for ~/.config/* and ~/main/config/*/*
mkdir_handle ~/.config

for dir in ~/config/*; do
  if [ -d "$dir" ]; then
    subdir_name=$(basename "$dir")

    mkdir_handle "$HOME/.config/$subdir_name"

    for file in "$dir"/*; do
      if [ -f "$file" ]; then
        ln -s "$file" "$HOME/.config/$subdir_name/$(basename "$file")"
      fi
    done
  fi
done
```
