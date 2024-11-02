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
* Software Installation
* Symbolic Linking of Configuration Files

This script will help us quickly configure a new system environment by pulling configurations from a Git repository and installing essential packages.

```bash
#!/bin/bash
# Step 1: Create a new directory for the config files
mkdir ~/setup # Create a new directory for storing config files
cd ~/setup # Change the current working directory to setup
# Step 2: Clone the configuration files
git init # Initialize a git repository
git clone https://gitlab.com/cit2420/2420-as2-starting-files main # Git clone the setup repository
# Step 3: Install the dependency and install packages
sudo pacman -S unzip # Install a package that is required for unzipping 
/main/bin/install-fonts # Run the install fonts script
/main/bin/sayhi # Print hello to console
```