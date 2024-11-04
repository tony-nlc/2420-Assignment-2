#!/bin/bash
# Step 1: Create a new directory for the config files
mkdir ~/setup # Create a new directory for storing config files
cd ~/setup    # Change the current working directory to setup
# Step 2: Clone the configuration files
git init                                                          # Initialize a git repository
git clone https://gitlab.com/cit2420/2420-as2-starting-files main # Git clone the setup repository
# Step 3: Install the dependency and install packages
sudo pacman -S unzip        # Install a package that is required for unzipping
sudo pacman -S kakoune tmux # Install two packages as user-defined
/main/bin/install-fonts     # Run the install fonts script
/main/bin/sayhi             # Print hello to console
