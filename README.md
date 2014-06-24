Install:
1. Need ruby 1.8.7, rails 2.3.5, gem 1.3.5
gem install -v=0.8.7 rake -V

2. change settings.rb


3. Install gitlist
see INSTALL.md of gitlist
In your virtualhost configuration you must change the AllowOverride option to All.

AddType application/x-httpd-php .php
<VirtualHost *:80>
    DocumentRoot "/var/www/gitlist"
    ServerName mygithub
    ErrorLog "/var/log/apache2/mygithub-error_log"
    CustomLog "/var/log/apache2/mygithub-access_log" common
    <Directory />
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order deny,allow
                Allow from all
    </Directory>
</VirtualHost>

--.htaccess

<IfModule mod_rewrite.c>
    Options -MultiViews

    RewriteEngine On
#    RewriteBase /Users/i027910/www/gitlist/

    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^(.*)$ index.php/$1 [L,NC]
</IfModule>
<Files config.ini>	
    order allow,deny
    deny from all
</Files>

#[SUSE] you need enable rewrite engine for apache2
vi /etc/sysconfig/apache2
add "rewrite" to variable APACHE_MODULES

# you need to manually create the first repo, other index.php cannot work
mkdir /var/mygithub
chmod 755 /var/mygithub
# if you going run ruby server under root, you need to install all gem (like mysql gem) under root
# suggest you use root install and run server
# suggest you chmod 777 /var/mygithub if you dev it on mac with your own users
cd /var/mygithub
sudo git init --bare test.git
sudo chown -R git:git test.git


3. create git user
sudo useradd -d /home/git -m git

groupadd git

usermod -G git git
su - git
ssh-keygen 
cp /home/git/.ssh/id_rsa.pub /home/git/.ssh/authorized_keys
-dd
