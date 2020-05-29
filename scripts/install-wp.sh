#!/bin/bash

#vars
dbname='wordpress'
dbuser='wp_user'
dbpass='wordpress'
            clear
            #sleep 30
            #sudo yum update -y
            sudo yum install -y httpd mariadb mariadb-server php php-common php-mysql php-gd php-xml php-mbstring php-mcrypt php-xmlrpc unzip wget
            sudo systemctl start httpd
            sudo systemctl start mariadb
            sudo systemctl enable httpd
            sudo systemctl enable mariadb
            #echo "<h1>This is the default website</h1>" > /var/www/html/index.html
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
            sudo wget http://wordpress.org/latest.tar.gz
            sudo tar -xzf latest.tar.gz
            sudo cp -ar wordpress/* /var/www/html/
            sudo mkdir -p /var/www/html/wp-content/uploads
            sudo touch wp-config.php
            sudo chown -R apache:apache /var/www/html/
            sudo chmod -R 755 /var/www/html/
            #sudo cp -av  wp-config-sample.php wp-config.php

            cd /var/www/html/
            
            cat << EOF > /var/www/html/wp-config.php
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
define( 'DB_NAME', '${dbname}' );

/** MySQL database username */
define( 'DB_USER', '${dbuser}' );

/** MySQL database password */
define( 'DB_PASSWORD', '${dbpass}' );

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

cat << EOF > /etc/httpd/conf.d/wordpress.conf
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
            
            cd ~
            sudo rm -rf wordpress*
            sudo rm -rf latest*
            #echo "DBNAME ${dbname}"
            #echo "DBUSER ${dbuser}"
            sudo systemctl restart httpd.service 
            
            exit