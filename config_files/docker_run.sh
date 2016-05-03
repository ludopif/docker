#!/bin/sh

if [ ! -f ./config/settings.inc.php  ]; then
	if [ $PS_DEV_MODE -ne 0 ]; then
		echo "\n* Enabling DEV mode ...";
		sed -ie "s/define('_PS_MODE_DEV_', false);/define('_PS_MODE_DEV_',\ true);/g" /var/www/html/config/defines.inc.php
	fi

	if [ $PS_HOST_MODE -ne 0 ]; then
		echo "\n* Enabling HOST mode ...";
		echo "define('_PS_HOST_MODE_', true);" >> /var/www/html/config/defines.inc.php
	fi

	if [ $PS_FOLDER_INSTALL != "install" ]; then
		echo "\n* Renaming install folder as $PS_FOLDER_INSTALL ...";
		mv /var/www/html/install /var/www/html/$PS_FOLDER_INSTALL/
	fi

	if [ $PS_FOLDER_ADMIN != "admin" ]; then
		echo "\n* Renaming admin folder as $PS_FOLDER_ADMIN ...";
		mv /var/www/html/admin /var/www/html/$PS_FOLDER_ADMIN/
	fi

	if [ $PS_HANDLE_DYNAMIC_DOMAIN = 0 ]; then
		rm /var/www/html/docker_updt_ps_domains.php
	else
		sed -ie "s/DirectoryIndex\ index.php\ index.html/DirectoryIndex\ docker_updt_ps_domains.php\ index.php\ index.html/g" /etc/apache2/apache2.conf
	fi

fi

# We need to remove the pid file or Apache won't start after being stopped
if [ -f /var/run/apache2/apache2.pid  ]; then
    rm -f /var/run/apache2/apache2.pid
fi

echo "\n* Almost ! Starting Apache now\n";
exec apache2 -DFOREGROUND
