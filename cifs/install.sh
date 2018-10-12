#!/bin/bash

get_input_return=""
get_input () {
	# requests input from the user
	# $1 is the prompt to the user.
	# $2 is a regex string to use for input validation.
	# $3 is an error message to display if validation fails. User will be prompted until input is valid.

	read -e -p "$1 " in
	if [[ in =~ $2 ]]; then
		get_input_return=$in
	else
		echo $3 1>&2
		get_input "$1" $2 "$3"
	fi
}

echo "Installing CIFS"
sudo apt install -y cifs-utils

read -e -n 1 -p "Would you like to configure a network share to mount on server startup? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
	get_input "What user will be using this share?" ^[a-zA-Z0-9_]*$ "Please enter a valid username!"
	user_name=$get_input_return
	get_input "Enter a name for this share:" ^[a-zA-Z0-9_]*$ "Please enter a single word using only letters, numbers, and underscores!"
	share_name=$get_input_return
	share_url=""
	get_input "Enter the URL of the server and share you'd like to mount in '//server/share' format:" .* "Please enter URL in //server/share format! (no trailing slash)"
	share_url=$get_input_return
	get_input "Enter a username for $share_name:" ^[a-zA-Z0-9]*$ "Please enter a valid username using only letters and numbers!"
	username=$get_input_return
	get_input "Enter a password for $share_name:" ^[a-zA-Z0-9]*$ "Please enter a valid password using only letters and numbers!"
	password=$get_input_return

	echo "Creating /media/$share_name..."
	sudo mkdir /media/$share_name
	
	credentials_file="/home/$user_name/.smbcredentials-$share_name"
	sudo cp .smbcredentials $credentials_file
	sudo sed -i "s/{cifs_username}/$username/" $credentials_file
	sudo sed -i "s/{cifs_password}/`echo ${password/$/\$} | sed "s/\&/\\\\\&/g"`/" $credentials_file
	sudo chown $user_name:$user_name $credentials_file
	sudo chmod 600 $credentials_file
	
	echo "Created credentials file for fstab at $credentials_file with the following contents..."
        sudo cat $credentials_file
        echo ""
	
	echo "Adding the following line to /etc/fstab..."
        echo "$share_url /media/$share_name cifs credentials=$credentials_file,iocharset=utf8,sec=ntlm 0 0 "

	if [ ! -f /etc/fstab.original ]; then
		sudo cp -n /etc/fstab /etc/fstab.original
		sudo chmod 400 /etc/fstab.original
	fi

	echo "Contents of /etc/fstab are currently:"
	echo "$share_url /media/$share_name cifs credentials=$credentials_file,iocharset=utf8,sec=ntlm 0 0 " | sudo tee -a /etc/fstab
else
	exit 0 
fi

echo "Creating user for Plex Media Server"
sudo adduser --disabled-password --home /home/$user_name --gecos "Plex Media Server account" plex

