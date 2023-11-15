#!/bin/bash

# arguments
echo -n "Set DB password: "
read DBPASS

# variables
REPO="bootcamp-devops-2023"

# verify root user
if [ "$(id -u)" -ne 0 ];
then
	echo "only root user can run this script"
	exit
fi

# update system
apt-get update

# install git
if dpkg -s git > /dev/null 2>&1;
then
	echo "git installed"
else
	echo "installing git"
	apt install git
fi

# install apache2
if dpkg -s apache2 > /dev/null 2>&1;
then
        echo "apache2 installed"
else
        echo "installing apache2"
        apt install apache2
fi

# instal php
if dpkg -s php > /dev/null 2>&1;
then
        echo "php installed"
else
        echo "installing php"
		sudo apt install php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl 

fi

systemctl start apache2
systemctl enable apache2
systemctl reload apache2
mv /var/www/html/index.html /var/www/html/index.html.bkp

# install curl
if dpkg -s curl > /dev/null 2>&1;
then
        echo "curl installed"
else
        echo "installing curl"
        apt install curl
fi

# download repository
if [ -d "$REPO" ];
then
        echo "updating repository"
        cd $REPO
        git checkout clase2-linux-bash
        git pull
        cd ..
else
        git clone -b clase2-linux-bash https://github.com/roxsross/$REPO.git
fi

# install mariadb-server
if dpkg -s mariadb-server > /dev/null 2>&1;
then
        echo "mariadb-server installed"
else
        echo "installing mariadb-server"
        apt install mariadb-server
fi

systemctl start mariadb
systemctl enable mariadb

mysql -e "
 CREATE DATABASE devopstravel;
 CREATE USER 'codeuser'@'localhost' IDENTIFIED BY '$DBPASS';
 GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
 FLUSH PRIVILEGES;"

mysql < ./$REPO/app-295devops-travel/database/devopstravel.sql

# copy files of the repository to apache folder
cp -r ./$REPO/app-295devops-travel/* /var/www/html/

# set pass db
OLDPASS='""'
sudo sed -i "s~$OLDPASS~'"$DBPASS"'~g" /var/www/html/config.php
