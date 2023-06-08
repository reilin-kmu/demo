FROM oraclelinux:7
MAINTAINER anderson

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
  && yum -y clean all && rm -rf /var/cache/yum
RUN yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
  && yum -y clean all && rm -rf /var/cache/yum

RUN yum-config-manager --enable remi-php74

RUN yum -y install \
  ImageMagick \
  ImageMagick-perl \
  libmemcached \
  wget \
  java \
  libaio \
  gcc++ \
  && yum -y clean all && rm -rf /var/cache/yum

RUN mkdir /rpm /script

COPY ./src/*.rpm /rpm/
RUN rpm -ivh /rpm/apache-commons-lang3-3.1-9.el7.noarch.rpm
RUN rpm -ivh /rpm/oracle-instantclient-basic-21.6.0.0.0-1.x86_64.rpm
RUN rpm -ivh /rpm/oracle-instantclient-devel-21.6.0.0.0-1.x86_64.rpm

RUN yum -y install \
  freetds \
  httpd \
  httpd-devel \
  memcached \
  mod_ssl \
  pcre-devel \
  pdftk \
  php \
  php-dbase \
  php-devel \
  php-gd \
  php-imagick \
  php-ldap \
  php-mbstring \
  php-mcrypt \
  php-mssql \
  php-mysql \
  php-oci8 \
  php-opcache \
  php-pdo \
  php-pear \
  php-pecl-apcu \
  php-pecl-memcached \
  php-pgsql \
  php-soap \
  php-ssh2 \
  php-zip \
  && yum -y clean all && rm -rf /var/cache/yum

COPY ./src/oel7/php.ini /etc/
COPY ./src/oel7/httpd.conf /etc/httpd/conf/
COPY ./src/oel7/conf.d/* /etc/httpd/conf.d/

ENV SERVERNAME wac.kmu.edu.tw
RUN echo "ServerName $SERVERNAME" >> /etc/httpd/conf/httpd.conf

COPY ./src/oel7/run.sh /run.sh
RUN chmod 755 /run.sh
CMD ["/run.sh"]

