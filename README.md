# 2420-Assignment-2
## Introduction

This repository contains two Bash scripts designed to simplify system administration in a Unix environment. These scripts aim to automate system setup and user management, following Bash best practices with robust error handling, detailed comments, and command-line options for flexibility.
Project Structure

1. System Setup Scripts: Automates system setup by installing essential packages and linking configuration files.
2. User Creation Script: Automates the creation of user accounts, including environment and permissions setup.
---
### Project 1: System Setup Scripts

The System Setup Scripts streamline essential setup tasks for a newly installed system. This script includes:

* Software Installation: Installs essential packages defined in a requirements file.

* Symbolic Linking of Configuration Files: Links user configuration files from a Git repository to the local system.

These scripts provide a fast way to configure a new environment by installing necessary software and linking configurations from a Git repository.
Script 1.1: Cloning Configuration & Installing Packages

This script installs packages listed in a `requirement` file.

> [!IMPORTANT]
> You need to create `requirement` in order to install packages
**How to create a requirement file**
```bash
touch requirement
```
**How to edit a requirement file**
```bash
nvim requirement
```
Then, press **i** then start typing the name of packages you wanted to install

**Example `requirement` File Format**
```
# Filename: requirement
# Description: User-defined list of packages

tmux
kakoune
unzip
# Add more as needed
```


**Sample Script**
```bash
#!/bin/bash
# Filename: setup
# Description: Initialize Git and install user-defined packages

# Step 1: Install dependencies and packages
if [[ -f requirement ]];then # Check if requirement exist
  sudo pacman -S $(cat requirement) # Installs packages listed in the 'requirement' file
else
  echo You have not create a requirement file # Print an error message
  exit # Exit the function
fi
```
Usage

1. Create a file named requirement with a list of packages.
2. Run the setup script.
3. Confirm installation when prompted by typing **Y** and pressing **Enter**.

**Script 1.2: Creating Symbolic Links**

This script links configuration files and binaries from a Git repository to the system's configuration directories.
Sample Script
```bash
#!/bin/bash
# Filename: link
# Description: Link configuration and binary files to local directories

# Error Handling Function
mkdir_handle() {
  if ! [[ -d $1 ]]; then # Check if directory does not exist
    mkdir -p $1 # Create directory if it doesnt exist
  fi
}

# Step 1: Clone configuration files
git init # Initialize a empty git repository
git clone https://gitlab.com/cit2420/2420-as2-starting-files main # Get the files from a remote git repository

# Step 2: Create symbolic links for binaries
mkdir_handle ~/bin # Handle if ~/bin already exist
for file in ~/main/bin/*; do # Loop over the files under /bin of the remote git repository
  ln -s "$file" ~/bin/$(basename "$file")
done

# Step 3: Create symbolic links for configuration files
mkdir_handle ~/.config
for dir in ~/main/config/*; do
  subdir_name=$(basename "$dir")
  mkdir_handle "$HOME/.config/$subdir_name"
  for file in "$dir"/*; do
    ln -s "$file" "$HOME/.config/$subdir_name/$(basename "$file")"
  done
done
```
**Script 1.3: Activating the Scripts**

Use the following script to run the setup and linking processes:
```bash
#!/bin/bash
# Filename: main
# Description: Run setup and link scripts

./setup   # Run setup script
./link    # Run link script
```
Make the main script executable:

```bash
sudo chmod u+x ./main
```

Example Screenshot
Installation Example
Project 2: User Creation Script

[Details for this section can be added here once specified.]
Usage

    Prepare the requirement file with the list of packages to install.
    Clone this repository and navigate into the directory.
    Make the scripts executable, e.g., chmod +x setup link main.
    Run the main script to install packages and link configuration files.

Let me know if you need further details or additional sections!