#bin/bash
if [ -f /tmp/first ];
	/usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/	--user=mysql 
	rm -rf /tmp/first
else
	/etc/init.d/httpd start
    /etc/init.d/mysqld start

	