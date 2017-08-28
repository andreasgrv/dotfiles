#!/bin/bash

# exit on failure
set -e

HERE=`dirname $(realpath $0)`
BACKUP_DIR=".confbkp"

# directories we need to create
dirs=$(find . -path  '*/*' -type d | \
	   grep -v -e '^./.git' | \
	   cut -c 3-)

# files we want to setup
files=$(find . -path  '*/*' -type f | \
	    grep -v -e '^./.git' -e '^./.\?setup' -e './README.md' | \
	   	cut -c 3-)

echo -e "This setup script works by making symbolic links\n\n\t$HERE -> $HOME\n"
echo -e "It also tries to keep a backup of replaced files in $HOME/$BACKUP_DIR\n"
# Modified from:
# https://stackoverflow.com/questions/226703/
# how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script
while true; do
	read -p "The following links (and folders) will be created in $HOME\
		 	 $(echo -e "\n\n$files") \
			 $(echo -e "\n\nDo you wish to proceed (y or n)? ")" yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) echo -e '\nRerun me if you change your mind!'; exit;;
		* ) echo "[Y]es or [N]o ?";;
	esac
done

# Create backup dir and folders we need in home directory
( echo "$BACKUP_DIR" ; echo "$dirs" ) | while read dr
do
	create_dir="$HOME/$dr"
	if [ ! -e "$create_dir" ]
	then
		echo "## Creating folder $create_dir"
		mkdir -p "$create_dir"
	else
		if [ ! -d "$create_dir" ]
		then
			echo "#E $create_dir exists and is not a directory"
			echo "#E Cannot create folder, exiting.."
			exit 1
		fi
	fi
done

# Create same folders in backup dir
echo "$dirs" | while read dr
do
	create_dir="$HOME/$BACKUP_DIR/$dr"
	if [ ! -e "$create_dir" ]
	then
		echo "## Creating folder $create_dir"
		mkdir -p "$create_dir"
	else
		if [ ! -d "$create_dir" ]
		then
			echo "#E $create_dir exists and is not a directory"
			echo "#E Cannot create folder, exiting.."
			exit 1
		fi
	fi
done

echo -e "## Linking following files from $HERE to $HOME:\n"
echo "$files" | while read f
do
	if [ -f "$HOME/$f" ]
	then
		mv -- "$HOME/$f" "$HOME/$BACKUP_DIR/$f"
		if [ $? != 0 ]
		then
			echo -e "#E Failed to move\n$HOME/$f -> \n$HOME/$BACKUP_DIR/$f\nexiting.."
			exit 1
		fi
	fi
	echo "$f"
	ln -s -T "$HERE/$f" "$HOME/$f"
	if [ $? != 0 ]
	then
		echo -e "#E Failed to link\n$HOME/$f -> $HERE/$f\n exiting.."
		exit 1
	fi
done

echo -e '## Building font cache\n'
fc-cache -fr
echo -e 'Done!\n'
