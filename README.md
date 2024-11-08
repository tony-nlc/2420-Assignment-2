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

---

#### Script 1.1: Cloning Configuration & Installing Packages

This script installs packages listed in `/home/<username>requirement` file or a **user defined path**.

> [!IMPORTANT]
> This script can take user input.
> Refer to Script 1.3

**How to create a requirement file**

```bash
touch requirement
```

**How to edit a requirement file**

```bash
nvim requirement
```

> [!TIP]
> 1. Press **i** then start typing the name of packages you wanted to install
> 2. Use **Enter** to separate packages

**Example `requirement` File Format**

```
tmux
kakoune
unzip
# Add more as needed
```

> [!TIP]
> 1. Press **esc** then start typing the name of packages you wanted to install
> 2. Enter **:wq** to save the requirement file

```bash
#!/bin/bash
# Filename: install
# Description: Initialize Git and install user-defined packages
# Reference:
# [1] https://ss64.com/bash/syntax-file-operators.html
# [2] https://ss64.com/bash/syntax-substitution.html
# [15] https://ss64.com/bash/tr.html

################################################################################
# Initiaiization                                                               #
################################################################################

# Set the username
username=$1
# Set the requirement filename
file_path=$2

################################################################################
# Main program                                                                 #
################################################################################

# Step 1: Install dependencies and packages

# Check if requirement exist
# -f checks if requirement is a regular file [1]
if [[ -f $file_path ]]; then
    # Installs packages listed in the 'requirement' file
    # $(cat requirement) will substitue the content of given file [2]
    # tr "\r" " " will replace all end of line to space
    pacman -S --needed --noconfirm  $(cat $file_path | tr "\r" " ")
else
    # Print an error message
    echo You have not create a requirement file
    # Exit the script
    exit 1
fi
```
> [!WARNING]
> You Should Not Run This Script Directly
---
#### Script 1.2: Creating Symbolic Links

This script links configuration files and binaries from a Git repository to the system's configuration directories.
Sample Script

> [!IMPORTANT]
> This script can take user input.
> Refer to Script 1.3

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
    echo File Already Exist with Path:$2
  fi
}

################################################################################
# Main program                                                                 #
################################################################################

# Step 1: Clone configuration files

# Install two packages needed
pacman -S --noconfirm --needed tmux kakoune
echo

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
  echo
else
  # Print an error message
  echo Remote Git Repository Already exists
  echo
fi

# Step 2: Create symbolic links for binaries

# Print a lookup message
echo /home/$username/bin
# Print a separate line
printf "%60s" " " | tr ' ' '-'
echo
# Handle if ~/bin already exist
make_directory /home/$username/bin
echo

# Loop over the files under /bin of the remote git repository
for file in /home/$username/remote/main/bin/*; do
  # Print a lookup message
  echo $file
  # Print a separate line
  printf "%60s" " " | tr ' ' '-'
  echo
  # Create a symbolic link from the source file to the ~/bin files [3]
  # "$file" represents the absolute path of the source file
  # $(basename "$file") extracts the filename [4]
  # The link will be created in /home/<username>/bin with the same name as the source file
  link "$file" "/home/$username/bin/$(basename "$file")"
  echo
done

# Step 3: Create symbolic links for configuration files

# Print a lookup message
echo /home/$username/.config
# Print a separate line
printf "%60s" " " | tr ' ' '-'
echo
# Handle if ~/.config already exist
make_directory /home/$username/.config
echo

# Loop over application directory under config folder in remote git repository 
for dir in /home/$username/remote/main/config/*; do
  # Get the basename of the directory [4]
  subdir_name=$(basename "$dir")
  # Print a lookup message
  echo $dir
  # Print a separate line
  printf "%60s" " " | tr ' ' '-'
  echo
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
  echo
done

# Step 4: Create symbolic links for bashrc file

# Print a lookup message
echo /home/$username/.bashrc
# Print a separate line
printf "%60s" " " | tr ' ' '-'
echo
# Create a symbolic link from the source file to the /home/arch/.bashc
link /home/$username/remote/main/home/bashrc /home/$username/.bashrc
```

> [!WARNING]
> You Should Not Run This Script Directly
---
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
file_path="/home/$user/requirement"

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
  echo "Usage: $0 -r <filepath> -u <username>"
  echo "  -r <filepath>           File path of requirement file"
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
    file_path=${OPTARG}
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

echo
echo Installing
# Print a separator line
printf "%60s" " " | tr ' ' '-'
echo
# Run  install script
./install $user $file_path
echo

echo Linking
# Print a separator line
printf "%60s" " " | tr ' ' '-'
echo
# Run link script
./link $user
echo
```

> [!IMPORTANT]
> Make The Three Scripts Executable
> ```bash
> # Add execute permission for user
> sudo chmod u+x ./install ./link ./setup 
> ```

Run the setup script to set up your system.
```bash
# Run the setup script for new user
sudo ./setup -r <Packages File Path> -u <username>
# Or you can setup for your current user
sudo ./setup
# Use -h option for usage
sudo ./setup -h 
```

> [!TIP]
> Run this command to verify the linking
> ```bash
> ls -la ~/bin ~/.bashrc ~/.config/kak/ ~/.config/tmux
> ```
---

### Project 2: User Creation Script

The User Creation Script streamline essential users configuration for a newly installed system. This script includes:

> [!NOTE]
>
> -   Shell Configuration
> -   Home Directory Setup
> -   Group Configuration

This script provide a fast way to configure a new user by configuring user's group and setting up for shell and home directory.

#### Script 2: User Creation Script

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
# [10] https://tldp.org/LDP/sag/html/adduser.html
# [11] https://opensource.com/article/19/12/help-bash-program
# [12] https://ss64.com/bash/getopts.html
# [13] https://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/
# [14] https://www.cyberciti.biz/faq/understanding-etcgroup-file/
# [16] https://ss64.com/bash/awk.html
# [17] https://stackoverflow.com/questions/55877410/understanding-how-ofs-works-in-awk
# [18] https://stackoverflow.com/questions/9708028/awk-return-value-to-shell-script
# [19] https://stackoverflow.com/questions/70384448/how-should-i-use-if-else-statement-in-awk
# [20] https://unix.stackexchange.com/questions/136322/how-to-replace-the-content-of-a-specific-column-with-awk
# [21] https://www.cyberciti.biz/faq/understanding-etcshadow-file/

################################################################################
# Initiaiization                                                               #
################################################################################

# Initialize a default shell variable
shell="/bin/bash"
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
    echo Directory Already Exist in Path:$1
  fi
}

################################################################################
# Help                                                                         #
################################################################################

# Show the usage of the script [11]
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

# Parsing option arguments to variable [12]
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
# awk -F: specifies to search and separate row by ":" [16]
# -v username="$username" specifies username we are looking up [16]
# $1 == username checks if first column is equal to username [19]
# print "User Found", returns a message [18]
# /etc/passwd is the file we are searching [13]
if [[ -n $(awk -F: -v username="$username" '$1 == username {print "Found"}' /etc/passwd) ]]; then
  # Print an error message showing username already exist
  echo "Username found in file"
  # Exit script
  exit 1
else
  # Print a success message
  echo "Valid Username"
fi

# Get the next avaliable UID
# awk -F: specifies to search and separate row by ":" [16]
# $3 >= 1000 && $3 <= 65533 specifies the range we are looking for [19]
# { if ($3 > max) max = $3 } Checks if third column UID column if larger than max a local variable [19]
# END specifies do the following action by the end [16]
# if (max >= 1000) checks if max >= 1000 [19]
# if yes, return the value max+1 [18]
# if no, return 1000 [18]
# /etc/passwd specifies the value we are looking for
uid=$(awk -F: '$3 >= 1000 && $3 <= 65533 { if ($3 > max) max = $3 } END { if (max >= 1000) print max+1; else print 1000 }' /etc/passwd)

# Get the next avaliable GID
# awk -F: specifies to search and separate row by ":" [16]
# $4 >= 1000 && $4 <= 65533 specifies the range we are looking for [19]
# { if ($4 > max) max = $4 } Checks if fourth column UID column if larger than max a local variable [19]
# END specifies do the following action by the end [16]
# if (max >= 1000) checks if max >= 1000 [19]
# if yes, return the value max+1 [18]
# if no, return 1000 [18]
# /etc/passwd specifies the value we are looking for
gid=$(awk -F: '$3 >= 1000 && $4 <= 65533 { if ($4 > max) max = $4 } END { if (max >= 1000) print max+1; else print 1000 }' /etc/passwd)

# Set a user_home variable [13]
user_home="/home/$username"
# Set a user_entry for /etc/passwd [13]
user_entry="$username:x:$uid:$gid:$info:$user_home:$shell"
# Append user_entry variable to /etc/passwd [13]
echo "$user_entry" >>/etc/passwd
# Append user_entry variable to /etc/shadow [21]
echo "$username:!*::::::" >>/etc/shadow
# Append user_entry variable to /etc/group [14]
echo "$username:x:$gid:" >>/etc/group

# Handle if user_home already exist
make_directory "$user_home"
# Copy skeleteon to user_home recursively [10]
cp -r /etc/skel/* "$user_home"
# Change ownership of user_home to user
chown -R "$username:$gid" "$user_home"
# Change access for user_home
chmod -R 751 "$user_home"

# Separate groups string into an array by comma
separated_groups=($(awk -F, '{for(i=1; i<=NF; i++) print $i}' <<<"$groups"))
# Loop over group in groups
for ((i = 0; i < ${#separated_groups[@]}; i++)); do
  # Check if group exists in /etc/group
  # awk -F: specifies to search and separate row by ":"
  # -v group="${separated_groups[i]}" specifies group name we are looking up
  # $1 == username checks if first column is equal to groupname
  # print "User Found", returns a message
  # /etc/passwd is the file we are searching
  if [[ -n $(awk -F: -v group="${separated_groups[i]}" '$1 == group {print "Found"}' /etc/group) ]]; then
    # specifies to search and separate row by ":"
    # -F: specifies separate by ":"
    # -v group="${groups[i]}" sepcifies the group we are editing
    # -v user="$username" specifies the username as variable
    # if ($1 == group) checks if the first column of the row matches to the group
    # if ($4 != "") checks if the fourth column of the row is not empty
    # $4 = $4 "," user appends our username to the fourth column
    # else if ($4 !~ "\\b" user "\\b") checks if column 4 do not have user variable's value in it
    # $4 = $4 "," user; append user variable's value to the fourth column
    # print $0 returns a new row if changed else the original row
    # >/etc/group.tmp will write the result to /etc/group.tmp which is temporary file store the edited /etc/group
    # && mv /etc/group.tmp /etc/group then rename /etc/group.tmp back to /etc/group
    # /etc/group is the file we are searching
    awk -F: -v group="${separated_groups[i]}" -v user="$username" 'BEGIN { OFS = ":" }
    {
      if ($1 == group) {
        if ($4 == "") {
          $4 = user;
        } else if ($4 !~ "\\b" user "\\b") {
          $4 = $4 "," user;
        }
      }
      print $0;
    }' /etc/group > /etc/group.tmp && mv /etc/group.tmp /etc/group
    # Print a success message
    echo "User $username added to group ${separated_groups[i]}"
  else
    echo "${separated_groups[i]} does not exist"
  fi
done

# Change password for that user
passwd $username
```

> [!IMPORTANT]
> Make the new_user Script Executable
> ```bash
> sudo chmod u+x ./new_user # Add execute permission for user
> ```

> [!NOTE]
> -s, -g, -i options are optional.
> Their Default Value are:
>```bash
> shell="/bin/bash"
> groups="wheel"
> info="Regular User"
>```

Run the new_user script to set up your system.
```bash
# Run the setup script for new user
sudo ./new_user -u <username> -s <shell path> -g <groups> -i <user info>
# Run -h option for help
sudo ./new_user -h
# Example to create a user
sudo ./new_user -u testing -s /bin/bash -g wheel -i testing
```

> [!TIP]
> Run this command to verify the user creation
> ```bash
> su <username>
> tail -1 /etc/passwd
> tail -1 /etc/shadow
> tail -1 /etc/group
> cat /etc/group | grep <username>
> ls -la ~
> ```