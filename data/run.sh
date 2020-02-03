#!/bin/bash
# HOMER 5 Docker Kamailio (http://sipcapture.org)
# run.sh {parameters}

# HOMER Options, defaults
DB_USER=homer_user
DB_PASS=homer_password
DB_HOST="127.0.0.1"
DB_PORT="5432"

# MYSQL SETUP
SQL_LOCATION=/homer-api/sql/pgsql

show_help() {
cat << EOF
Usage: ${0##*/} 
Homer5 Docker parameters:

    --dbpass -p             PgSQL password (homer_password)
    --dbuser -u             PgSQL user (homer_user)
    --dbhost -h             PgSQL host (127.0.0.1)
    --dbport -P             PgSQL port (5432)

EOF
exit 0;
}

# Set container parameters
while true; do
  case "$1" in
    -p | --dbpass )
      if [ "$2" == "" ]; then show_help; fi;
      DB_PASS=$2;
      echo "DB_PASS set to: $DB_PASS";
      shift 2 ;;
    -P | --dbport )
      if [ "$2" == "" ]; then show_help; fi;
      DB_PORT=$2;
      echo "DB_PORT set to: $DB_PORT";
      shift 2 ;;
    -h | --dbhost )
      if [ "$2" == "" ]; then show_help; fi;
      DB_HOST=$2;
      echo "DB_HOST set to: $DB_HOST";
      shift 2 ;;
    -u | --dbuser )
      if [ "$2" == "" ]; then show_help; fi;
      DB_USER=$2;
      echo "DB_USER set to: $DB_USER";
      shift 2 ;;
    --help )
      show_help;
      exit 0 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# HOMER API CONFIG
PATH_HOMER_CONFIG=/var/www/html/api/configuration.php
chmod 775 $PATH_HOMER_CONFIG

# Replace values in template
perl -p -i -e "s/\{\{ DB_PASS \}\}/$DB_PASS/" $PATH_HOMER_CONFIG
perl -p -i -e "s/\{\{ DB_HOST \}\}/$DB_HOST/" $PATH_HOMER_CONFIG
perl -p -i -e "s/\{\{ DB_USER \}\}/$DB_USER/" $PATH_HOMER_CONFIG
perl -p -i -e "s/\{\{ DB_PORT \}\}/$DB_PORT/" $PATH_HOMER_CONFIG

# Set Permissions for webapp
mkdir /var/www/html/api/tmp
chmod -R 0777 /var/www/html/api/tmp/
chmod -R 0775 /var/www/html/store/dashboard*
export PATH_ROTATION_SCRIPT=/opt/homer_pgsql_rotate
export PATH_ROTATION_INI=/opt/rotation.ini
chmod 775 $PATH_ROTATION_SCRIPT
chmod +x $PATH_ROTATION_SCRIPT
perl -p -i -e "s/homer_user/$DB_USER/" $PATH_ROTATION_INI
perl -p -i -e "s/homer_password/$DB_PASS/" $PATH_ROTATION_INI
perl -p -i -e "s/localhost/$DB_HOST/" $PATH_ROTATION_INI
perl -p -i -e "s/5432/$DB_PORT/" $PATH_ROTATION_INI
head -n 10 $PATH_ROTATION_INI

# Init rotation
/opt/homer_pgsql_rotate > /dev/null 2>&1

# Start the cron service in the background for rotation
cron -f &
service rsyslog start
a2enmod rewrite
a2enmod php5
service apache2 stop

export APACHE_LOCK_DIR=/var/lock
export APACHE_PID_FILE=/var/run/apache2.pid
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
export APACHE_LOG_DIR=/var/log
export APACHE_RUN_DIR=/var/run
apache2ctl -DFOREGROUND
