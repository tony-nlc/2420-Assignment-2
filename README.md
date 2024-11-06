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
> Create `requirement` in order to install packages

**How to create a requirement file**
```bash
touch requirement
```
**How to edit a requirement file**
```bash
nvim requirement
```

>[!TIP]
> Press **i** then start typing the name of packages you wanted to install

**Example `requirement` File Format**
```bash
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
# Reference:
  # [1] https://ss64.com/bash/syntax-file-operators.html
  # [2] https://ss64.com/bash/syntax-substitution.html

# Step 1: Install dependencies and packages
if [[ -f requirement ]];then 
  # Check if requirement exist
  # -f checks if requirement is a regular file [1]
  sudo pacman -S $(cat requirement) 
  # Installs packages listed in the 'requirement' file
  # $(cat requirement) will substitue the content of requirement [2]
else
  echo You have not create a requirement file # Print an error message
  exit # Exit the function
fi
```
**Usage**

1. Create a file named requirement with a list of packages.
2. Run the setup script.

![install_iamge](https://github.com/tony-nlc/2420-Assignment-2/blob/main/assets/install.png)

3. Confirm installation when prompted by typing **Y** and pressing **Enter**.

**Script 1.2: Creating Symbolic Links**

This script links configuration files and binaries from a Git repository to the system's configuration directories.
Sample Script
```bash
#!/bin/bash
# Filename: link
# Description: Link configuration and binary files to local directories
# Reference:
  # [3] https://ss64.com/bash/ln.html 
  # [4] https://ss64.com/bash/basename.html 
  # [5] https://git-scm.com/docs/git-init 
  # [6] https://git-scm.com/docs/git-clone 
# Error Handling Function
mkdir_handle() {
  if ! [[ -d $1 ]]; then 
    # Check if directory does not exist [1]
    mkdir $1 # Create directory if it doesnt exist
  fi
}

# Step 1: Clone configuration files
git init # Initialize a empty git repository [5]
git clone https://gitlab.com/cit2420/2420-as2-starting-files main 
# Get the files from a remote git repository [6]

# Step 2: Create symbolic links for binaries
mkdir_handle ~/bin # Handle if ~/bin already exist
for file in ~/main/bin/*; do 
  # Loop over the files under /bin of the remote git repository
  echo "Linking $(basename $file)"
  # Print a message of what file we are handling
  ln -s "$file" ~/bin/$(basename "$file")
  # Create a symbolic link from the source file to the ~/bin files [3]
  # -s option specifies it is a symbolic link
  # "$file" represents the absolute path of the source file
  # $(basename "$file") extracts the filename without the path [4]
  # The link will be created in ~/bin with the same name as the source file
done

# Step 3: Create symbolic links for configuration files
mkdir_handle ~/.config # Handle if ~/bin already exist
for dir in ~/main/config/*; do
  # Loop over application directory under config folder in remote git repository 
  subdir_name=$(basename "$dir")
  echo "Looking up under $subdir_name"
  # Get the basename of the directory [4]
  mkdir_handle "~/.config/$subdir_name" 
  # Handle if ~/.config/<application> already exist
  for file in "$dir"/*; do
    # Loop over the file under the application directory
    echo "Linking $(basename $file)"
    # Print a message of what file we are handling
    ln -s "$file" "~/.config/$subdir_name/$(basename "$file")"
    # Create a symbolic link from the source file to the ~/.config/<application>/ config file [3]
    # -s option specifies it is a symbolic link
    # "$file" represents the absolute path of the source file
    # $(basename "$file") extracts the filename without the path [4]
    # The link will be created in ~/bin with the same name as the source file
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
> [!IMPORTANT]
> Make the main script executable
> ```bash
> sudo chmod u+x ./main # Add execute permission for user
> ```

Run the main script to set up your system.
```bash
./main # Run the main script
```
---

Installation Example
Project 2: User Creation Script

[Details for this section can be added here once specified.]
Usage

    Prepare the requirement file with the list of packages to install.
    Clone this repository and navigate into the directory.
    Make the scripts executable, e.g., chmod +x setup link main.
    Run the main script to install packages and link configuration files.

Let me know if you need further details or additional sections!