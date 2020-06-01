#!/bin/bash
#set -x
#vars
    dbname='wordpress'
    dbuser='wp_user'
    dbpass='wordpress'
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
            sudo cp -ar wordpress/* /var/www/html/
            sudo mkdir -p /var/www/html/wp-content/uploads
            sudo touch wp-config.php
            sudo chown -R apache:apache /var/www/html/
            sudo chmod -R 755 /var/www/html/
            #sudo cp -av  wp-config-sample.php wp-config.php

            cd /var/www/html/
            
            sudo cat << EOF > /var/www/html/wp-config.php
 <?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wp_user' );

/** MySQL database password */
define( 'DB_PASSWORD', 'wordpress' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
EOF

sudo cat << EOF > /etc/httpd/conf.d/wordpress.conf
<VirtualHost *:80>
    DocumentRoot "/var/www/html"
   

    DirectoryIndex index.html index.php
    <Directory /var/www/html>
      Options FollowSymLinks
      AllowOverride All
      Require all granted
  </Directory>
    # Other directives here
</VirtualHost>

EOF


            echo "Please verify your install and go to http://your-ip"
            
            sudo chown -R apache:apache /var/www/html/
            sudo chmod -R 755 /var/www/html/
            
            cd ~
            sudo rm -rfv wordpress*
            sudo rm -rfv latest*
             
            php -v
            echo
            echo "Finished provisioning!"
            exit 0