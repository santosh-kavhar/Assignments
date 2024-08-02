#!/bin/bash 
# add -x to above command for debugging

# DONE: Check if already command is done
# DONE: Redirect SDRERR to error.log file
# NOTE: spaces matter near '[ ]'
# 

readPassword(){
	echo "Please enter your password: "
	read -s PASSWORD
}

menu(){
	echo -e "Choose your installation menu: \n1. mySQL \n2. htop and curl \n3. python \n4. goLang\n5. docker"
	read  choice

	case $choice in
		"1") MySQL
		;;

		"2") HtopAndCurl
		;;

		"3") Python
		;;

		"4") GoLang
		;;

		"5") Docker
		;;

		*)
		echo "Invalid choice"
		;;
	esac

}

thanks(){
	echo "Thank you and visit again!!"
}

##
## 1. mySQL Installation
##
#

MySQL() {
	#Check for mysql version
	mysql --version 2>> error.log
	#Install mysql-server
	# $? gives output of last command, 0 means python already existed	
	if [ $? -ne 0 ]; then
		echo $PASSWORD | sudo -S apt update 2>> error.log
		echo $PASSWORD | sudo -S apt install mysql-server 2>> error.log
	else
		echo "mysql-server already exists!!"
	fi

	# Enable mysql service
	echo $PASSWORD | sudo -S systemctl enable mysql.service 2>> error.log
	echo $PASSWORD | sudo -S  systemctl start mysql.service 2>> error.log

	# Verify mysql is running
	echo $PASSWORD | sudo -S systemctl status mysql.service 2>> error.log	

	# Modify password for SQL
	echo $PASSWORD| sudo -S mysql -u root --skip-password 2>> error.log
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'PASSWORD'"| sudo mysql -u root -p 2>> error.log
	# CREATE database test;
	echo "create database test" | sudo mysql -u root -p 2>> error.log

}


##
## 2. htop and curl installation
##

HtopAndCurl(){
	# Install htop if it doesn't exist
	htop --version 2>> error.log
	# $? gives output of last command, 0 means python already existed	
	if [ $? -ne 0 ]; then 
		echo $PASSWORD | sudo -S apt update 2>> error.log
		echo $PASSWORD | sudo -S apt install htop 2>> error.log
	else
		echo "htop already exists!!"
	fi

	# Install curl if it doesn't exist
	curl --version
	# $? gives output of last command, 0 means python already existed	
	if [ $? -ne 0 ]; then 
		echo $PASSWORD | sudo -S apt update 2>> error.log
		echo $PASSWORD | sudo -S apt install curl 2>> error.log
	else
		echo "curl already exists!!"
	fi
}


##
## 3. python3 install
## 

Python(){
	# Install python if it doesn't exist
	python3 --version 2>> error.log
	# $? gives output of last command, 0 means python already existed	
	if [ $? -ne 0 ]; then 
		echo $PASSWORD | sudo -S apt update 2>> error.log
		echo $PASSWORD | sudo -S  apt install python3 2>> error.log
		# Print version
		python3 --version 2>> error.log
	else
		echo "python3 already exists!!"
	fi
}


##
## 4. goLang install
##

GoLang(){
	# Install go-lang if it doesn't exist
	go version 2>> error.log
	if [ $? -ne 0 ]; then 
		echo $PASSWORD | sudo -S apt install golang-go 2>> error.log
		# Print version
		go version
	else
		echo "go already exists!!"
	fi
}


#
##
## 5. docker install
##

Docker(){
	# Check docker version
	docker --version 2>> error.log
	# $? gives output of last command, 0 means python already existed	
	if [ $? -ne 0 ]; then 
		# Setup docker's apt repository
		#
		## Add Docker's official GPG key:
		echo $PASSWORD | sudo -S apt-get update 2>> error.log
		echo $PASSWORD | sudo -S apt-get install ca-certificates curl 2>> error.log
		echo $PASSWORD | sudo -S install -m 0755 -d /etc/apt/keyrings 2>> error.log
		echo $PASSWORD | sudo -S curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc 2>>error.log
		echo $PASSWORD | sudo -S chmod a+r /etc/apt/keyrings/docker.asc 2>> error.log

		# Add the repository to Apt sources:
		echo \
  		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  		echo $PASSWORD | sudo -S tee /etc/apt/sources.list.d/docker.list > /dev/null
		echo $PASSWORD | sudo -S apt-get update 2>> error.log
		echo $PASSWORD | sudo -S apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>> error.log
	else
		echo "docker already exists!!"
	fi

	docker --version 2>> error.log
	echo $PASSWORD | sudo -S systemctl status docker 2>> error.log

	echo $PASSWORD | sudo -S groupadd docker 2>> error.log

	echo $PASSWORD | sudo -S usermod -aG docker $USER 2>> error.log


	docker pull nginx:latest 2>>error.log
	# docker run hello-world
}

# Functions are called HERE!
# Read the password at start
readPassword
# Options to install
menu
thanks

