Step 1: Please make sure these packages are installed in your local machine.

sudo apt install kamailio kamailio-postgres-modules kamailio-json-modules kamailio-geoip-modules kamailio-extra-modules

Step 2: Make sure log facility and log rotate are set up. Please expose HEP port so that HEP clients can connect to it.
Also make sure your postgres ip is correct.

#!KAMAILIO
####### Global Parameters definitions #########
#!substdef "!HOMER_DB_USER!homer_user!g"
#!substdef "!HOMER_DB_PASSWORD!homer_password!g"
#!substdef "!HOMER_DB_HOST!127.0.0.1!g"
#!substdef "!HOMER_DB_PORT!5432!g"

#!substdef "!HOMER_LISTEN_PROTO!udp!g"
#!substdef "!HOMER_LISTEN_IF!172.31.122.159!g"
#!substdef "!HOMER_LISTEN_PORT!9060!g"
#!substdef "!HOMER_STATS_SERVER!tcp:HOMER_LISTEN_IF:8889!g"

#!substdef "!CALLID_ALEG_HEADER!X-CID!g"

#!define WITH_HOMER_GEO
#!define WITH_HOMER_CUSTOM_STATS

####### Global Parameters #########
debug=3
log_stderror=no
log_facility=LOG_LOCAL0

