# 2420-Assignment-2

## Introduction

This repository contains two Bash scripts designed to simplify system administration in a Unix environment. These scripts aim to automate system setup and user management, following Bash best practices with robust error handling, detailed comments, and command-line options for flexibility.
Project Structure

1. System Setup Scripts: Automates system setup by installing essential packages and linking configuration files.
2. User Creation Script: Automates the creation of user accounts, including environment and permissions setup.

---

### Project 1: System Setup Scripts

The System Setup Scripts streamline essential setup tasks for a newly installed system. This script includes:

> [!NOTE]
>
> -   Package Installation
> -   Symbolic Linking of Configuration Files

These scripts provide a fast way to configure a new environment by installing necessary software and linking configurations from a Git repository.

#### Script 1.1: Cloning Configuration & Installing Packages

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

> [!TIP]
> Press **i** then start typing the name of packages you wanted to install

**Example `requirement` File Format**

```
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
if [[ -f /home/arch/requirement ]];then 
  # Check if requirement exist
  # -f checks if requirement is a regular file [1]
  pacman -S --noconfirm $(cat requirement | tr "\r" " ") 
  # Installs packages listed in the 'requirement' file
  # $(cat requirement) will substitue the content of requirement [2]
else
  echo You have not create a requirement file # Print an error message
  exit 1                                      # Exit the script
fi
```

#### Script 1.2: Creating Symbolic Links

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


# Error handling Function for mkdir
make_directory() {
  if ! [[ -d $1 ]]; then 
    # Check if directory does not exist [1]
    mkdir $1 # Create directory if it doesnt exist
  fi
}


# Error handling Function for ln
link() {
  local source=$1       # Declare a local variable source
  local destination=$2  # Declare a local variable destination
  if ! [[ -e $2 ]];then # Check if the destination file does not exist
    echo "Linking $(basename $1) to $2" # Print a handling message
    ln -s $1 $2         # Create a symbolic from source to destination
  else
    echo File Already Exist in Path:$2 # Print an error message
  fi
}


# Step 1: Clone configuration files
if ! [[ -d /home/arch/remote ]];then # Check if git remote directory does not exist
  make_directory /home/arch/remote   # Create a new remote directory
  cd /home/arch/remote               # Change directory to remote
  git init                           # Initialize a empty git repository [5]
  git clone https://gitlab.com/cit2420/2420-as2-starting-files main 
  # Get the files from a remote git repository [6]
  cd /home/arch                      # Change directory back to /home/arch
fi


# Step 2: Create symbolic links for binaries
make_directory /home/arch/bin # Handle if ~/bin already exist

for file in /home/arch/remote/main/bin/*; do 
  # Loop over the files under /bin of the remote git repository
  link "$file" /home/arch/bin/$(basename "$file")
  # Create a symbolic link from the source file to the ~/bin files [3]
  # "$file" represents the absolute path of the source file
  # $(basename "$file") extracts the filename [4]
  # The link will be created in /home/arch/bin with the same name as the source file
done


# Step 3: Create symbolic links for configuration files
make_directory /home/arch/.config # Handle if ~/bin already exist
pacman -S --noconfirm tmux kakoune

for dir in /home/arch/remote/main/config/*; do
  # Loop over application directory under config folder in remote git repository 
  subdir_name=$(basename "$dir")                    # Get the basename of the application [4]
  echo "Looking up under $subdir_name"              # Get the basename of the directory [4]
  make_directory "/home/arch/.config/$subdir_name"  # Handle if ~/.config/<application> already exist
  for file in "$dir"/*; do                          # Loop over the file under the application directory
    link "$file" "/home/arch/.config/$subdir_name/$(basename "$file")"
    # Create a symbolic link from the source file to the /home/arch/.config/<application>/ config file [3]
    # "$file" represents the absolute path of the source file
    # $(basename "$file") extracts the filename without the path [4]
    # The link will be created in ~/bin with the same name as the source file
  done
done


# Step 4: Create symbolic links for bashrc file
link /home/arch/remote/main/home/bashrc /home/arch/.bashrc
# Create a symbolic link from the source file to the /home/arch/.bashc
```

#### Script 1.3: Activating the Scripts

Use the following script to run the setup and linking processes:

```bash
#!/bin/bash
# Filename: setup
# Description: Run setup and link scripts
# Reference: https://ss64.com/bash/ps.html [8]


if [[ $UID -ne 0 ]];then                # Check if the script is run by root privillege [8]
  echo "You need to 'sudo' this script" # Print an error message
  exit 1                                # Exit the script
fi
./install                               # Run setup script
./link                                  # Run link script
```

> [!IMPORTANT]
> Make the main script executable
>
> ```bash
> sudo chmod u+x ./install # Add execute permission for user
> sudo chmod u+x ./link # Add execute permission for user
> sudo chmod u+x ./setup # Add execute permission for user
> ```

Run the main script to set up your system.

```bash
./setup # Run the main script
```

---

### Project 2: User Creation Script

The User Creation Scripts streamline essential users configuration for a newly installed system. This script includes:

> [!NOTE]
> -   Shell Configuration
> -   Home Directory Setup
> -   Group Configuration

These scripts provide a fast way to configure a new user by configuring user's group and setting up for shell and home directory.

#### Script 2.1