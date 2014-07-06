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

4. hana for ruby
[on mac]
#install unixodbc
brew install unixodbc
# if it make link failed and prompt you link it
brew link unixodbc


[linux SUSE]
install unixOdbc
sudo zypper install unixODBC-devel unixODBC

ln -sf /home/jackie/sap/hdbclient/libodbcHDB.so /usr/lib/libodbcHDB.so
# must edit /etc/odbc.ini not /etc/unixODBC/odbc.ini, it's a bug of unixODBC
# sudo vi /etc/unixODBC/odbc.ini 
sudo vi /etc/odbc.ini
[DSN1]
driver=/usr/lib/libodbcHDB.so
servernode=10.58.114.228:30115


install ruby odbc(http://www.ch-werner.de/rubyodbc/)
download http://www.ch-werner.de/rubyodbc/ruby-odbc-0.99995.gem 
gem install --local  ruby-odbc-0.99995.gem 

rails setup https://wiki.wdf.sap.corp/wiki/display/ic/Documentation#Documentation-RailsSetup
gem 'ruby-odbc'
gem 'activerecord-odbc-adapter'

gem install activerecord-hana-adapter (https://github.com/SAP/activerecord-hana-adapter)
(install from git source
git clone https://github.com/SAP/activerecord-hana-adapter.git
cd activerecord-hana-adapter/
gem build activerecord-hana-adapter.gemspec 
gem install --local activerecord-hana-adapter-0.1.2.gem)


app store
ruby script/server -p 3001 -e production
oce
ruby script/server -p 3000 -e production
review
ruby script/server -p 3002

# hana command line tool
/home/jackie/sap/hdbclient/hdbsql -n 10.58.114.210:30015 -u system -p manager

# create hana odbc adapter
/usr/lib64/ruby/gems/1.8/gems/activerecord-odbc-adapter-2.0/


tips:
find /usr/lib64/ruby/gems/1.8/gems/activerecord-odbc-adapter-2.0 -name "*.rb" |xargs grep "drop_table"
find ~/.gem/ruby/ -name "*.rb" |xargs grep "drop_table"
sudo vi /usr/lib64/ruby/gems/1.8/gems/activerecord-odbc-adapter-2.0/lib/active_record/vendor/odbcext_hdb.rb
vi /home/jackie/.gem/ruby/1.8/gems/activerecord-2.3.5/lib/active_record/schema.rb