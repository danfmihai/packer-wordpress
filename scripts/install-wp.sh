#!/bin/bash

            sudo yum update -y
            sudo yum install -y httpd mariadb mariadb-server php php-common php-mysql php-gd php-xml php-mbstring php-mcrypt php-xmlrpc unzip wget
            sudo systemctl start httpd
            sudo systemctl start mariadb
            sudo systemctl enable httpd
            sudo systemctl enable mariadb
            echo "<h1>This is the default website</h1>" > /var/www/html/index.html
            mysql -u root -e "CREATE DATABASE wordpress;"
            mysql -u root -e "GRANT ALL PRIVILEGES on wordpress.* to 'wp_user'@'localhost' identified by 'wordpress';"
            mysql -u root -e "FLUSH PRIVILEGES;"
            echo "Database setup done!"
            echo
            echo "Installing Wordpress...\"
            sudo wget http://wordpress.org/latest.tar.gz
            sudo tar -xzvf latest.tar.gz
            sudo rm -rf wordpress*
            sudo rm -rf latest*
            sudo cp -avr wordpress/* /var/www/html/
            sudo mkdir /var/www/html/wp-content/uploads
            sudo chown -R apache:apache /var/www/html/
            sudo chmod -R 755 /var/www/html/
            cd /var/www/html/
            sed -e "s/database_name_here/"wordpress"/" -e "s/username_here/"wp_user"/" -e "s/password_here/"wordpress"/" wp-config-sample.php > wp-config.php
            cat <<EOF
            ##############
            WORDPRESS IS INSTALLED!
            ##############
            EOF
            echo "Please verify your install and go to http://ip"
exit