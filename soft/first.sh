#!/bin/bash
if [ -f /tmp/first ]
then
	mkdir /usr/local/mysql/data/
	chmod 775 /usr/local/mysql/data/
	chown mysql:mysql /usr/local/mysql/data/
	/usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/	--user=mysql 
	rm -rf /tmp/first
fi
/etc/init.d/httpd start
/etc/init.d/mysqld start