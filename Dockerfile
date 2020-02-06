FROM debian:jessie

# Default baseimage settings
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Update and upgrade apt
RUN apt-get update -y \
 && apt-get install --no-install-recommends --no-install-suggests -y postgresql-client nano cron geoip-database geoip-database-extra rsyslog ca-certificates perl libdbi-perl libclass-dbi-pg-perl apache2 libapache2-mod-php5 php5 php5-cli php5-gd php-pear php5-dev php5-pgsql php5-json php-services-json git wget pwgen curl \
 && a2enmod php5

WORKDIR /

# HOMER 5
RUN git clone https://github.com/yatyanng/homer-api.git /homer-api \
 && git clone -b '5.0.6' --single-branch https://github.com/yatyanng/homer-ui.git /homer-ui \
 && chmod -R +x /homer-api/scripts/pgsql/* && cp -R /homer-api/scripts/pgsql/* /opt/ \
 && cp -R /homer-api/api /var/www/html/ \
 && cp -R /homer-ui/* /var/www/html/ \
 && chown -R www-data:www-data /var/www/html/store/ \
 && chmod -R 0775 /var/www/html/store/dashboard 

COPY data/configuration.php /var/www/html/api/configuration.php 
COPY data/preferences.php /var/www/html/api/preferences.php
COPY data/vhost.conf /etc/apache2/sites-enabled/000-default.conf
COPY data/angular.js /var/www/html/lib/angular/angular.js
RUN touch /var/log/cron.log \ 
 && echo "30 3 * * * /opt/homer_pgsql_rotate >> /var/log/cron.log 2>&1" > /etc/cron.d/homer_pgsql_rotate.conf 
COPY data/apache2.conf /etc/apache2/apache2.conf
COPY data/run.sh /run.sh
RUN chmod a+rx /run.sh

# UI
EXPOSE 80
ENTRYPOINT ["/run.sh"]
