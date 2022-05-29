# ONQUADRO Database

## Requirements

- Docker
- Docker Compose

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

The SQL schema is available in [docker-entrypoint-initdb.d/1-db-create.sql](docker-entrypoint-initdb.d/1-db-create.sql) file.

Visual representation:

![To update this image, please run `schemaspy-run`](schema.svg)

## Clean up

To start fresh:

``` sh
docker-compose rm
```

## DB Dump

When the database is filled with data, run:

``` sh
docker exec --user postgres qbase pg_dump --data-only --role qbase qbase | zstdmt > $(date -I)-qbase.sql.zst
```

To restore the dump, start with PostgreSQL  __without__ `qbase` user and __without__ `qbase` database. Then, run:
``` sh
cat docker-entrypoint-initdb.d/1-db-create.sql | psql
zstdcat $(date -I)-qbase.sql.zst | psql
``` 
