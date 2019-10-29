# QBASE

## Requirements

- Docker
- docker-compose
- Java 8+

## Running PostgreSQL

``` sh
docker-compose up
```

By default, PostgreSQL will be available with this config:

- Host: `localhost`
- Port: `15432`
- Schema: `public`
- User: `qbase`
- Password: `Jellux37`
- Database: `qbase`

## Schema

To update schema, please run `schemaSpy`. The result will be in `/tmp/qbase-schema`

![](schema.png) 

## DB Dump

When the database is filled with data, run:

``` sh
docker exec --user postgres qbase pg_dump --data-only --role qbase qbase | xz --threads=0 > $(date -I)-qbase.sql.xz
```

To restore the dump, start with Postgres DB __without__ `qbase` user and __without__ `qbase` database. Then, run:
``` sh
cat docker-entrypoint-initdb.d/1-db-create.sql | psql
xzcat $(date -I)-qbase.sql.xz | psql
```
