#!/bin/bash
#set -x
#vars
        sed -i 's/\(SELINUX=\)\(.*\)/\1permissive/' /etc/selinux/config
        dbname='wordpress'
        dbuser='wp_user'
        dbpass='wordpress'
        curl http://169.254.169.254/latest/meta-data/public-ipv4 > pub_ip.txt
        ip4=$(cat pub_ip.txt)
            #sudo dnf update `  w1q1y76tu58-y
            
            sudo dnf install -y httpd mariadb mariadb-server unzip wget nano bash-completion yum-utils
            # install php 7
            #sudo dnf install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
            #sudo dnf-config-manager --enable remi-php73
            sudo dnf install -y php php-common php-opcache php-cli php-gd php-curl php-mysqlnd php-xml php-mbstring php-xmlrpc
           # Start and enable boot startup for httpd and mysql
            sudo usermod -a -G apache ec2-user
            sudo systemctl start httpd
            sudo systemctl start mariadb
            sudo systemctl enable httpd
            sudo systemctl enable mariadb
            
            # Create database
            mysql -u root -e "CREATE DATABASE IF NOT EXISTS $dbname;"
            mysql -u root -e "GRANT ALL PRIVILEGES on ${dbname}.* to '${dbuser}'@'localhost' identified by '${dbpass}';"
            mysql -u root -e "FLUSH PRIVILEGES;"
            mysql -u root -e "show databases;" 
            echo
            echo "Database setup done!"
            echo
            echo "Installing Wordpress..."
            echo
            cd ~
            if [ ! -f latest.tar.gz ]; then
                sudo wget http://wordpress.org/latest.tar.gz
            fi    
            sudo tar -xzf latest.tar.gz
            sudo mkdir -p /var/www/html/wp/
            sudo cp -ar wordpress/* /var/www/html/wp/
                        
            sudo chown -R apache:apache /var/www/html/
            sudo chmod -R 755 /var/www/html/
            #sudo cp -av  wp-config-sample.php wp-config.php

            cd /var/www/html/wp/
            

sudo cat << EOF > /etc/httpd/conf.d/wordpress.conf
<VirtualHost *:80>
    DocumentRoot "/var/www/html/wp"
    ServerName ${ip4}
    DirectoryIndex index.html index.php
    <Directory /var/www/html/wp>
      Options FollowSymLinks
      AllowOverride All
      Require all granted
  </Directory>
    # Other directives here
</VirtualHost>

EOF


            echo "Please verify your install and go to http://${ip4}"
            
            sudo chown -R apache:apache /var/www/html/
            sudo chmod -R 755 /var/www/html/
            
            cd ~
            sudo rm -rfv wordpress*
            sudo rm -rfv latest*
            
            getenforce
            php -v
            echo
            echo "Finished provisioning!"
            exit 0