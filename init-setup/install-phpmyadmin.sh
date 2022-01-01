#!/bin/bash

# INFO: for systems based on Red Hat

yum install -y phpmyadmin && RANDOMPATH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 11 | head -n 1) # Se deberia ejecutar luego de haber aplicado la clase jb_spacewalk

cat << EOF > /etc/httpd/conf.d/phpMyAdmin.conf
# phpMyAdmin - Web based MySQL browser written in php
# 
# Allows only localhost by default
#
# But allowing phpMyAdmin to anyone other than localhost should be considered
# dangerous unless properly secured by SSL
Alias /phpMyAdmin-basicstring /usr/share/phpMyAdmin
Alias /phpmyadmin-basicstring /usr/share/phpMyAdmin
<Directory /usr/share/phpMyAdmin/>
   AddDefaultCharset UTF-8
   <IfModule mod_authz_core.c>
     # Apache 2.4
     <RequireAny>
       Require ip 127.0.0.1
       Require ip ::1
       Include conf/allow/customluis.allow
     </RequireAny>
   </IfModule>
   <IfModule !mod_authz_core.c>
     # Apache 2.2
     Order Deny,Allow
     Deny from All
     Allow from 127.0.0.1
     Allow from ::1
     Include conf/allow/customluis.allow
   </IfModule>
</Directory>
<Directory /usr/share/phpMyAdmin/setup/>
   <IfModule mod_authz_core.c>
     # Apache 2.4
     <RequireAny>
       Require ip 127.0.0.1
       Require ip ::1
       Include conf/allow/customluis.allow
     </RequireAny>
   </IfModule>
   <IfModule !mod_authz_core.c>
     # Apache 2.2
     Order Deny,Allow
     Deny from All
     Allow from 127.0.0.1
     Allow from ::1
     Include conf/allow/customluis.allow
   </IfModule>
</Directory>
# These directories do not require access over HTTP - taken from the original
# phpMyAdmin upstream tarball
#
<Directory /usr/share/phpMyAdmin/libraries/>
    Order Deny,Allow
    Deny from All
    Allow from None
</Directory>
<Directory /usr/share/phpMyAdmin/setup/lib/>
    Order Deny,Allow
    Deny from All
    Allow from None
</Directory>
<Directory /usr/share/phpMyAdmin/setup/frames/>
    Order Deny,Allow
    Deny from All
    Allow from None
</Directory>
# This configuration prevents mod_security at phpMyAdmin directories from
# filtering SQL etc.  This may break your mod_security implementation.
#
#<IfModule mod_security.c>
#    <Directory /usr/share/phpMyAdmin/>
#        SecRuleInheritance Off
#    </Directory>
#</IfModule>
EOF

sed -i "s/-basicstring/-${RANDOMPATH}/g" /etc/httpd/conf.d/phpMyAdmin.conf
 
# Habilitar almacenamiento de configuración
# Crear base de datos phpmyadmin
cd /usr/share/phpMyAdmin/sql/
mysql -u root --password=`grep password ~/info/mysql.info | cut -d '"' -f2 | cut -d "=" -f2` -e "CREATE DATABASE phpmyadmin;"
mysql -u root --password=`grep password ~/info/mysql.info | cut -d '"' -f2 | cut -d "=" -f2` phpmyadmin < create_tables.sql
mysql -u root --password=`grep password ~/info/mysql.info | cut -d '"' -f2 | cut -d "=" -f2` -e 'GRANT SELECT, INSERT, DELETE, UPDATE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY "Pmasecret*07000"'

sed -i "s/pmapass/Pmasecret*07000/g" /etc/phpMyAdmin/config.inc.php

systemctl reload httpd
