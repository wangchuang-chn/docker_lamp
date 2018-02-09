FROM centos:6.9

MAINTAINER wangchuang

ENV HTTPD_VERSION 2.2.34
ENV APR_VERSION 1.6.3
ENV APR_UTIL_VERSION 1.6.1
ENV MYSQL_VERSION 5.6.39
ENV PHP_VERSION 7.0.27


COPY soft /usr/local/src/


WORKDIR /usr/local/src/
RUN yum -y install gcc-c++ expat-devel cmake ncurses-devel perl libxml2-devel\
	&& tar xf httpd-${HTTPD_VERSION}.tar.gz \
	&& tar xf apr-${APR_VERSION}.tar.gz \
	&& tar xf apr-util-${APR_UTIL_VERSION}.tar.gz \
	&& tar xf mysql-${MYSQL_VERSION}.tar.gz \
	&& tar xf php-${PHP_VERSION}.tar.gz \
	&& useradd httpd \
	&& useradd mysql \
	&& cd apr-${APR_VERSION} \
	&& ./configure --prefix=/usr/local/apr && make && make install \
	&& cd /usr/local/src/apr-util-${APR_UTIL_VERSION} \
	&& ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr && make && make install \
	&& cd /usr/local/src/httpd-${HTTPD_VERSION} \
	&& ./configure --prefix=/usr/local/httpd --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --enable-so \
	&& make && make install\
	&& cd /usr/local/src/mysql-${MYSQL_VERSION} \
	&& cmake \
 -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
 -DDEFAULT_CHARSET=utf8 \
 -DDEFAULT_COLLATION=utf8_general_ci \
 -DWITH_EXTRA_CHARSETS=all \
 -DWITH_MYISAM_STORAGE_ENGINE=1 \
 -DWITH_INNOBASE_STORAGE_ENGINE=1 \
 -DWITH_MEMORY_STORAGE_ENGINE=1 \
 -DWITH_READLINE=1 \
 -DENABLED_LOCAL_INFILE=1 \
 -DMYSQL_DATADIR=/usr/local/mysql/data \
 -DMYSQL-USER=mysql \
    && make && make install \
    && rm -rf /usr/local/mysql/data \
    && rm -rf /usr/local/mysql/mysql-test \
    && yum -y remove cmake \
    && ls -l /usr/local/src/ \
    && cd /usr/local/src/php-${PHP_VERSION} \
    && ./configure --prefix=/usr/local/php --with-apxs2=/usr/local/httpd/bin/apxs --with-mysql=/usr/local/mysql \
    && make && make install \
    && cp /usr/local/httpd/bin/apachectl /etc/init.d/httpd \
    && cp /usr/local/src/mysql-${MYSQL_VERSION}/support-files/mysql.server.sh /etc/init.d/mysqld \
	&& cp /usr/local/src/my.cnf /etc/ \
    && chmod +x  /etc/init.d/mysqld \
    && yum clean all \
	&& rm -rf /usr/local/httpd/conf/httpd.conf\
    && cp  /usr/local/src/httpd.conf /usr/local/httpd/conf/httpd.conf \
    && echo "export PATH=$PATH:/usr/local/httpd/bin/:/usr/local/php/bin/:/usr/local/mysql/bin/" >> /etc/profile \
	&& touch /tmp/first \
	&& cp /usr/local/src/first.sh /opt/ \
	&& rm -rf /usr/local/src/* \
	&& source /etc/profile \

EXPOSE 80 443

CMD  /opt/first.sh
