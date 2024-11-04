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
