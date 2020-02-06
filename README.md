This is a custom homer5 docker. 

It uses kamailio instead of opensips.

It also uses external postgres instead of mysql.

Beware! Please read pgsql/README.md and kamailio/README.md

BUILD:
docker build . -t pk-homer5

RUN:
docker run -ti -p 172.31.122.159:80:80 pk-homer5:latest --dbhost 172.31.122.159
