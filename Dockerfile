# This docker file is for the automated build on docker hub
FROM ubuntu:16.04

LABEL maintainer="e_ben_75-python@yahoo.com" \
      description="This is a Observium Server" \
      package-name="observium" \
      image-version="1.0"

RUN apt-get update \
    && apt-get install -y libapache2-mod-php7.0 \
    php7.0-cli \
    php7.0-mysql \
    php7.0-mysqli \
    php7.0-gd \
    php7.0-mcrypt \
    php7.0-json \
    php-pear \
    snmp \
    fping \
    mysql-client \
    python-mysqldb \
    rrdtool \
    subversion \
    whois \
    mtr-tiny \
    ipmitool \
    graphviz \
    imagemagick \
    apache2 \
    cron \
    nano \
    && apt-get clean \
    && mkdir -p /opt/observium \
    && mkdir /opt/observium/logs \
    && mkdir /opt/observium/rrd

COPY ./observium-community-latest.tar.gz /opt/
COPY ./config.php /opt/observium/
COPY ./observium.conf /etc/apache2/sites-available/
COPY ./root /var/spool/cron/crontabs/

WORKDIR /opt
    
RUN tar zxvf observium-community-latest.tar.gz \
    && a2dissite 000-default.conf \
    && a2ensite observium.conf \
    && phpenmod mcrypt \
    && a2dismod mpm_event \
    && a2enmod mpm_prefork \
    && a2enmod php7.0 \
    && a2enmod rewrite
    # && /opt/observium/discovery.php -u \
    # && /opt/observium/adduser.php root 123456 10

EXPOSE 80 443 514/udp 161/udp 162/udp

ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
