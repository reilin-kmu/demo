FROM oraclelinux:8
MAINTAINER anderson

RUN dnf -y install epel-release \
  && dnf -y clean all && rm -rf /var/cache/dnf
RUN dnf -y install http://rpms.remirepo.net/enterprise/remi-release-8.rpm \
  && dnf -y clean all && rm -rf /var/cache/dnf

RUN dnf -y module enable php:remi-8.2

RUN dnf -y install \
  ImageMagick \
  ImageMagick-perl \
  libmemcached \
  wget \
  java \
  libaio \
  gcc \
  && dnf -y clean all && rm -rf /var/cache/dnf

RUN mkdir /rpm /script

COPY ./src/*.rpm /rpm/
RUN rpm -ivh /rpm/oracle-instantclient-basic-21.6.0.0.0-1.x86_64.rpm
RUN rpm -ivh /rpm/oracle-instantclient-devel-21.6.0.0.0-1.x86_64.rpm

RUN dnf -y install \
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
  && dnf -y clean all && rm -rf /var/cache/dnf

ENV SERVERNAME wac82.kmu.edu.tw

COPY ./src/oel8/script/* /script/
RUN chmod +x /script/runbatch.sh \
  && sh /script/runbatch.sh

RUN sed -i "s/ServerName test.kmu.edu.tw/ServerName ${SERVERNAME}/g" /etc/httpd/conf/httpd.conf

COPY ./src/oel8/run.sh /run.sh
RUN chmod +x /run.sh
CMD /run.sh

# COPY www /var/www
