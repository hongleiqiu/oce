Install:
1. Need ruby 1.8.7, rails 2.3.5, gem 1.3.5
2.  Install gitlist

In your virtualhost configuration you must change the AllowOverride option to All.

<VirtualHost *:80>
    DocumentRoot "/Users/i027910/www/gitlist"
    ServerName mygithub
    ErrorLog "/private/var/log/apache2/mygithub-error_log"
    CustomLog "/private/var/log/apache2/mygithub-access_log" common
    <Directory />
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order deny,allow
                Allow from all
    </Directory>
</VirtualHost>

