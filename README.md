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
# Filename: setup
# Description: Run setup and link scripts
# Reference:
# [8] https://ss64.com/bash/ps.html
# [9] https://ss64.com/bash/sudo.html

################################################################################
# Initiaiization                                                               #
################################################################################

# Set a variable for username
user=$SUDO_USER
# Set a requirement variable default value as requirement
requirement="requirement"

################################################################################
# Error Handling                                                               #
################################################################################

# Check if the script is run by root privillege [8]
if [[ $EUID -ne 0 ]]; then
  # Print an error message
  echo "You need to 'sudo' this script"
  # Exit the script
  exit 1
fi

################################################################################
# Help                                                                         #
################################################################################

# Show the usage of the script
show_help() {
  echo "Usage: $0 -r <filename> -u <username>"
  echo "  -r <filename>           Filename of requirement file"
  echo "  -u <user>               User we are linking the config and bin"
  exit 0
}

################################################################################
# Main program                                                                 #
################################################################################

# Parsing argument into variable
while getopts ":r:u:h" opt; do
  case "${opt}" in
  r)
    # Assign OPTARG's value to requirement
    requirement=${OPTARG}
    ;;
  u)
    # Assign OPTARG's value to user variable
    user=${OPTARG}
    ;;
  h)
    # Print help message
    show_help
    ;;
  :)
    # Exit script if OPTARGV is missing
    exit 1
    ;;
  ?)
    # Exit script for invalid option
    exit 1
    ;;
  esac
done

# Run  install script
./install $user $requirement
# Run link script
./link $user # Run link script
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
# [12] https://phoenixnap.com/kb/bash-comment

################################################################################
# Initiaiization                                                               #
################################################################################

# Set username variable
username=$1

################################################################################
# Error Handling                                                               #
################################################################################

# Error handling Function for mkdir
make_directory() {
  # Check if directory does not exist [1]
  if ! [[ -d $1 ]]; then
    # Create directory if it doesnt exist
    mkdir $1
  else
    # Print an error message
    echo Directory Already Exist in Path:$1
  fi
}

# Error handling Function for ln
link() {
  # Declare a local source destination
  local source=$1
  # Declare a local variable destination
  local destination=$2
  # Check if the destination file does not exist
  if ! [[ -e $2 ]]; then
    # Print a handling message
    echo "Linking $(basename $1) to $2"
    # Create a symbolic from source to destination
    ln -s $1 $2
  else
    # Print an error message
    echo File Already Exist in Path:$2
  fi
}

################################################################################
# Main program                                                                 #
################################################################################

# Step 1: Clone configuration files

# Check if git remote directory does not exist
if ! [[ -d /home/$username/remote ]]; then
  # Create a new remote directory
  make_directory /home/$username/remote
  # Change directory to remote
  cd /home/$username/remote
  #Initialize a empty git repository [5]
  git init
  # Get the files from a remote git repository [6]
  git clone https://gitlab.com/cit2420/2420-as2-starting-files main
  # Change directory back to /home/<username>
  cd /home/$username
fi

# Step 2: Create symbolic links for binaries

# Handle if ~/bin already exist
make_directory /home/$username/bin
# Loop over the files under /bin of the remote git repository
for file in /home/$username/remote/main/bin/*; do
  # Create a symbolic link from the source file to the ~/bin files [3]
  # "$file" represents the absolute path of the source file
  # $(basename "$file") extracts the filename [4]
  # The link will be created in /home/<username>/bin with the same name as the source file
  link "$file" "/home/$username/bin/$(basename "$file")"
done

# Step 3: Create symbolic links for configuration files

# Handle if ~/.config already exist
make_directory /home/$username/.config
# Install two packages needed
pacman -S --noconfirm tmux kakoune

# Loop over application directory under config folder in remote git repository 
for dir in /home/$username/remote/main/config/*; do
  # Get the basename of the directory [4]
  subdir_name=$(basename "$dir")
  # Print a lookup message
  echo "Looking up under $subdir_name"
  # Handle if ~/.config/<application> already exist
  make_directory "/home/$username/.config/$subdir_name"
  # Loop over the file under the application directory
  for file in "$dir"/*; do
    # Create a symbolic link from the source file to the /home/arch/.config/<application>/ config file [3]
    # "$file" represents the absolute path of the source file
    # $(basename "$file") extracts the filename without the path [4]
    # The link will be created in ~/bin with the same name as the source file
    link "$file" "/home/$username/.config/$subdir_name/$(basename "$file")"
  done
done

# Step 4: Create symbolic links for bashrc file

# Create a symbolic link from the source file to the /home/arch/.bashc
link /home/$username/remote/main/home/bashrc /home/$username/.bashrc
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

################################################################################
# Initiaiization                                                               #
################################################################################

# Set a variable for username
user=$SUDO_USER
# Set a requirement variable default value as requirement
requirement="requirement"

################################################################################
# Error Handling                                                               #
################################################################################

# Check if the script is run by root privillege [8]
if [[ $EUID -ne 0 ]]; then
  # Print an error message
  echo "You need to 'sudo' this script"
  # Exit the script
  exit 1
fi

################################################################################
# Help                                                                         #
################################################################################

# Show the usage of the script
show_help() {
  echo "Usage: $0 -r <filename> -u <username>"
  echo "  -r <filename>           Filename of requirement file"
  echo "  -u <user>               User we are linking the config and bin"
  exit 0
}

################################################################################
# Main program                                                                 #
################################################################################

# Parsing argument into variable
while getopts ":r:u:h" opt; do
  case "${opt}" in
  r)
    # Assign OPTARG's value to requirement
    requirement=${OPTARG}
    ;;
  u)
    # Assign OPTARG's value to user variable
    user=${OPTARG}
    ;;
  h)
    # Print help message
    show_help
    ;;
  :)
    # Exit script if OPTARGV is missing
    exit 1
    ;;
  ?)
    # Exit script for invalid option
    exit 1
    ;;
  esac
done

# Run  install script
./install $user $requirement
# Run link script
./link $user # Run link script
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
# - Specify a shell
# - Create home directory
# - Clone /etc/skel
# - Group configuration
# - Setup password
# Reference:
# [10] https://unix.stackexchange.com/questions/153225/what-steps-to-add-a-user-to-a-system-without-using-useradd-adduser
# [11] https://opensource.com/article/19/12/help-bash-program
# [12] https://ss64.com/bash/getopts.html
# [13] https://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/
# [14] https://www.cyberciti.biz/faq/understanding-etcgroup-file/

################################################################################
# Initiaiization                                                               #
################################################################################

# Initialize a default shell variable
shell="bin/bash"
# Initialize a default string for groups
groups="wheel"
# Initialize a default info for user
info="Regular User"

################################################################################
# Error Handling                                                               #
################################################################################

# Check if the script is run by root privillege [8]
if [[ $EUID -ne 0 ]]; then
  # Print an error message
  echo "You need to 'sudo' this script"
  # Exit the script
  exit 1
fi

# Error handling Function for mkdir
make_directory() {
  # Check if directory does not exist [1]
  if ! [[ -d $1 ]]; then
    # Create directory if it doesnt exist
    mkdir $1
  else
    # Print an error message
    echo Directory Already Exist in Path:$2
  fi
}

################################################################################
# Help                                                                         #
################################################################################

# Show the usage of the script
show_help() {
  echo "Usage: $0 -u <username> -s <shell> -g <group1,group2,...> -i <User ID Info>"
  echo "  -u <username>           Username of the new user (required)"
  echo "  -s <shell>              User's shell (default: /bin/bash)"
  echo "  -g <group>              Comma-separated list of additional groups"
  echo "  -i <User ID Info>       Extra information about the user"
  exit 0
}

################################################################################
# Main program                                                                 #
################################################################################

# Parsing option arguments to variable
while getopts ":u:s:g:i:h" opt; do
  case "${opt}" in
  # Passing $OPTARG to username variable
  u) username=$OPTARG ;;
  # Passing $OPTARG to shell variable
  s) shell=$OPTARG ;;
  # Passing $OPTARG to groups variable
  g) groups=$OPTARG ;;
  # Passing $OPTARG to info variable
  i) info=$OPTARG ;;
  # Print help message
  h) show_help ;;
  # Exit the function if they are missing an $OPTARG
  :) exit 1 ;;
  # Exit the function if user pass in invalid option
  ?) exit 1 ;;
  esac
done

# Check is username is empty
if [[ -z "$username" ]]; then
  # Print an error message
  echo "Error: Username is required."
  # Print help message
  show_help
fi

# Check if username already exists in /etc/passwd
if [[ -n $(awk -F: -v username="$username" '$1 == username {print "String found in line:", $0}' /etc/passwd) ]]; then
  # Print an error message showing username already exist
  echo "Username found in file"
  # Exit script
  exit 1
else
  # Print a success message
  echo "Valid Username"
fi

# Get the next avaliable UID
uid=$(awk -F: '$3 >= 1000 && $3 <= 65533 { if ($3 > max) max = $3 } END { if (max >= 1000) print max+1; else print 1000 }' /etc/passwd)
# Get the next avaliable GID
gid=$(awk -F: '$3 >= 1000 && $4 <= 65533 { if ($4 > max) max = $4 } END { if (max >= 1000) print max+1; else print 1000 }' /etc/passwd)

# Set a user_home variable
user_home="/home/$username"
# Set a user_entry for /etc/passwd
user_entry="$username:x:$uid:$gid:$info:$user_home:$shell"
# Append user_entry variable to /etc/passwd
echo "$user_entry" >>/etc/passwd
# Append user_entry variable to /etc/shadow
echo "$username:!*::::::" >>/etc/shadow
# Append user_entry variable to /etc/group
echo "$username:x:$gid:" >>/etc/group

# Handle if user_home already exist
make_directory "$user_home"
# Copy skeleteon to user_home recursively
cp -r /etc/skel/. "$user_home"
# Change ownership of user_home to user
chown -R "$username:$gid" "$user_home"
# Change access for user_home
chmod -R 751 "$user_home"

# Separate groups string into an array by comma
groups=($(awk -F, '{for(i=1; i<=NF; i++) print $i}' <<<"$groups"))
# Loop over group in groups
for ((i = 0; i < ${#groups[@]}; i++)); do
  # Search over /etc/group
  # -F: specifies separate by ":"
  # -v group="${groups[i]}" sepcifies the group we are editing
  # -v user="$username" specifies the username as variable
  # if ($1 == group) checks if the first column of the row matches to the group
  # if ($4 != "") checks if the fourth column of the row is not empty
  # $4 = $4 "," user appends our username to column 4
  # else $4 = user set the value of column 4 to user
  # print $0 returns a new row if changed else the original row
  # >/etc/group.tmp will write the result to /etc/group.tmp which temporary store the edited /etc/group
  # && mv /etc/group.tmp /etc/group then rename /etc/group.tmp back to /etc/group
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
    }' /etc/group >/etc/group.tmp && mv /etc/group.tmp /etc/group
  # Print a success message
  echo "User $username added to group ${groups[i]}"
done

# Change password for that user
passwd $username
```