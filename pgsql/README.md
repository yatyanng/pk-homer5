Step 1: Create a postgres accessible folder called '/data/homer'  after installing the postgresql-server package.


Step 2: Please run the sql scripts in the following order.

2a. homer_user.sql (Also read its content yourself, apply "psql homer_configuration and CREATE EXTENSION pgcrypto;" when 2c is done.)
2b, homer_tablespace.sql 
2c. homer_databases.sql

2d. schema_configuration.sql
2e. schema_data.sql
2f. schema_statistic.sql

Step 3: Grant access to any incoming pgsql client and listen to all network interfaces.
/etc/postgresql/10/main/postgresql.conf
/etc/postgresql/10/main/pg_hba.conf

Do restart postgres after change.
