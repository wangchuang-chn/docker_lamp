#!/bin/bash
who
if [ -f /tmp/first ]
then
	mkdir -v /usr/local/mysql/data/
	chmod -R 775 /usr/local/mysql/data/
	chown -R mysql:mysql /usr/local/mysql/data/
	/usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/	--user=mysql 
	rm -rf /tmp/first
fi
/etc/init.d/httpd start
/etc/init.d/mysqld start