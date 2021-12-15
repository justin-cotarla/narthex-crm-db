# Narthex CRM Database

This repo is used to version schemas for Narthex CRM. 

It contains design files for the schema, DDLs for the database, as well as a container for local development and testing.

## Development Container

A docker-compose setup is provided for spinning up a container running MySQL preloaded with the NarthexCRM schema.

### Requirements
- [Docker](https://docs.docker.com/get-docker/)

### Setup
The container expects an environment file for setting the main user's password. This file must first be created before running the container in `docker/.private.env` and must have following structure:

```bash
MYSQL_PASSWORD=[string]
```

Once the environment file is created, build the container:

```bash
$ cd docker
$ docker-compose build
```


### Running the Container
Once built, the container can be started via docker-compose:
```bash
$ docker-compose up
```
Upon first run, the database will execute `narthex_crm.sql` and build the schema from the DDL.

### Connecting to the Database
The container exposes the port 3306 for connecting to the database from an external application. It is also possible to spawn a `mysql` shell from within the container:
```bash
$ docker-compose exec narthex-crm-db mysql -uroot -p narthex_crm_db
```
This will prompt for the root password provided in `.private.env`, as described above.

### Tearing Down the Database Volume
The database saves its data in a persistant volume. To clear the volume run:
```bash
$ docker-compose down -v
```