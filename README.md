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
> Create `requirement` file in order to install packages

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
> Use **Enter** to separate packages

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
# Filename: install
# Description: Initialize Git and install user-defined packages
# Reference:
  # [1] https://ss64.com/bash/syntax-file-operators.html
  # [2] https://ss64.com/bash/syntax-substitution.html


################################################################################
# Initiaiization                                                               #
################################################################################

username=$1 # Set the username
filename=$2 # Set the requirement filename

################################################################################
# Main program                                                                 #
################################################################################
# Step 1: Install dependencies and packages

# Check if requirement exist
# -f checks if requirement is a regular file [1]
if [[ -f /home/$username/$requirement ]];then 
  # Installs packages listed in the 'requirement' file
  # $(cat requirement) will substitue the content of given file [2]
  # tr "\r" " " will replace all end of line to space
  pacman -S --noconfirm $(cat /home/$username/$filename | tr "\r" " ") 
else
  # Print an error message
  echo You have not create a requirement file 
  # Exit the script
  exit 1                                      
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

# Set username
username=$1

# Error handling Function for mkdir
make_directory() {
  if ! [[ -d $1 ]]; then 
                                         # Check if directory does not exist [1]
    mkdir $1                             # Create directory if it doesnt exist
  else
    echo Directory Already Exist in Path:$2
  fi
}


# Error handling Function for ln
link() {
  local source=$1                        # Declare a local variable source
  local destination=$2                   # Declare a local variable destination
  if ! [[ -e $2 ]];then                  # Check if the destination file does not exist
    echo "Linking $(basename $1) to $2"  # Print a handling message
    ln -s $1 $2                          # Create a symbolic from source to destination
  else
    echo File Already Exist in Path:$2   # Print an error message
  fi
}


# Step 1: Clone configuration files
if ! [[ -d /home/$username/remote ]];then # Check if git remote directory does not exist
  make_directory /home/$username/remote   # Create a new remote directory
  cd /home/$username/remote               # Change directory to remote
  git init                           # Initialize a empty git repository [5]
  git clone https://gitlab.com/cit2420/2420-as2-starting-files main 
  # Get the files from a remote git repository [6]
  cd /home/$username                      # Change directory back to /home/<username>
fi


# Step 2: Create symbolic links for binaries
make_directory /home/$username/bin # Handle if ~/bin already exist

for file in /home/$username/remote/main/bin/*; do 
  # Loop over the files under /bin of the remote git repository
  link "$file" "/home/$username/bin/$(basename "$file")"
  # Create a symbolic link from the source file to the ~/bin files [3]
  # "$file" represents the absolute path of the source file
  # $(basename "$file") extracts the filename [4]
  # The link will be created in /home/<username>/bin with the same name as the source file
done


# Step 3: Create symbolic links for configuration files
make_directory /home/$username/.config # Handle if ~/bin already exist
pacman -S --noconfirm tmux kakoune

for dir in /home/$username/remote/main/config/*; do
  # Loop over application directory under config folder in remote git repository 
  subdir_name=$(basename "$dir")                    # Get the basename of the application [4]
  echo "Looking up under $subdir_name"              # Get the basename of the directory [4]
  make_directory "/home/$username/.config/$subdir_name"  # Handle if ~/.config/<application> already exist
  for file in "$dir"/*; do                          # Loop over the file under the application directory
    link "$file" "/home/$username/.config/$subdir_name/$(basename "$file")"
    # Create a symbolic link from the source file to the /home/arch/.config/<application>/ config file [3]
    # "$file" represents the absolute path of the source file
    # $(basename "$file") extracts the filename without the path [4]
    # The link will be created in ~/bin with the same name as the source file
  done
done


# Step 4: Create symbolic links for bashrc file
link /home/$username/remote/main/home/bashrc /home/$username/.bashrc
# Create a symbolic link from the source file to the /home/arch/.bashc
```

#### Script 1.3: Activating the Scripts

Use the following script to run the setup and linking processes:

```bash
#!/bin/bash
# Filename: setup
# Description: Run setup and link scripts
# Reference: 
# [8] https://ss64.com/bash/ps.html 
# [9] https://ss64.com/bash/sudo.html


user=$SUDO_USER
if [[ $EUID -ne 0 ]];then                # Check if the script is run by root privillege [8]
  echo "You need to 'sudo' this script"  # Print an error message
  exit 1                                 # Exit the script
fi


./install $user                          # Run setup script
./link $user                             # Run link script
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
sudo ./setup # Run the setup script
```

---

### Project 2: User Creation Script

The User Creation Scripts streamline essential users configuration for a newly installed system. This script includes:

> [!NOTE]
> -   Shell Configuration
> -   Home Directory Setup
> -   Group Configuration

These scripts provide a fast way to configure a new user by configuring user's group and setting up for shell and home directory.

#### Script 2
```bash
#!/bin/bash
# Filename: new_user
# Description: Create a new user with the following:
# Specify a shell
# Create home directory
# Clone /etc/skel
# Group configuration
# Setup password
# Reference:
#


show_help() {
    echo "Usage: $0 -u <username> -s <shell> -g <group1,group2,...> -i <User ID Info>"
    echo "  -u <username>           Username of the new user (required)"
    echo "  -s <shell>              User's shell (default: /bin/bash)"
    echo "  -g <group>              Comma-separated list of additional groups"
    echo "  -i <User ID Info>       Extra information about the user"
    exit 0
}

shell="bin/bash"
group=()
info="Regular User"

while getopts ":u:s:g:i:h" opt; do
  case "${opt}" in
    u) username=$OPTARG ;;
    s) shell=$OPTARG ;;
    g) groups=$OPTARG ;; 
    i) info=$OPTARG ;;
    h) show_help ;;
    :) exit 1 ;;
    ?) exit 1 ;;
  esac
done

if [[ -z "$username" ]]; then
    echo "Error: Username is required."
    show_help
fi

if [[ -n $(awk -F: -v username="$username" '$1 == username {print "String found in line:", $0}' /etc/passwd) ]]; then
    echo "Username found in file"
    exit 1
else
    echo "Username not found in file"
fi

uid=$(awk -F: '$3 >= 1000 && $3 <= 65533 { if ($3 > max) max = $3 } END { if (max >= 1000) print max+1; else print 1000 }' /etc/passwd)
gid=$(awk -F: '$3 >= 1000 && $4 <= 65533 { if ($4 > max) max = $4 } END { if (max >= 1000) print max+1; else print 1000 }' /etc/passwd)
user_home="/home/$username"
user_entry="$username:x:$uid:$gid:$info:$user_home:$shell"
echo "$user_entry" >> /etc/passwd
echo "$username:!*::::::" >> /etc/shadow
echo "$username:x:$gid:" >> /etc/group


mkdir -p "$user_home"
cp -r /etc/skel/. "$user_home"
chown -R "$username:$gid" "$user_home"

groups=($(awk -F, '{for(i=1; i<=NF; i++) print $i}' <<< "$groups"))
for ((i=0; i<${#groups[@]}; i++)); do

    awk -F: -v group="${groups[i]}" -v user="$username" '
    {
    if ($1 == group) {
        if ($4 != "") {
            $4 = $4 "," user;
        } else {
            $4 = user;
        }
    }
    print $0;
    }' /etc/group > /etc/group.tmp && mv /etc/group.tmp /etc/group
    echo "User $username added to group ${groups[i]}"
done
```