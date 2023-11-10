- [Unidata RAMADDA Docker](#h-58AAF24A)
  - [Introduction](#h-440D6E11)
    - [Quickstart](#h-2B7ACAE3)
  - [Versions](#h-833DC148)
  - [Prerequisites](#h-23902167)
  - [Installation](#h-4DC46B26)
  - [Usage](#h-232B8397)
    - [Memory](#h-A19AC365)
    - [Docker compose](#h-31327E59)
      - [Running RAMADDA](#h-B6696F84)
      - [Stopping RAMADDA](#h-4F5F0E81)
      - [Delete RAMADDA Container](#h-105EE424)
    - [RAMADDA](#h-1D163FA5)
      - [Create RAMADDA Directories](#h-FA04ED59)
      - [RAMADDA pw.properties File](#h-A3E47BAB)
    - [Upgrading](#h-3A7881FD)
    - [Check What is Running](#h-7A9DACE9)
      - [curl](#h-004CE742)
      - [docker ps](#h-B3CF66F2)
  - [Configuration](#h-7781CDC8)
    - [Docker compose](#h-16477010)
      - [Basic](#h-475FD8D0)
    - [Tomcat](#h-442C5DE6)
    - [Java Configuration Options](#h-F0219C98)
    - [Configurable Tomcat UID and GID](#h-15BF48EB)
    - [HTTP Over SSL](#h-BAD3F95E)
  - [Support](#h-4585A68C)



<a id="h-58AAF24A"></a>

# Unidata RAMADDA Docker

Dockerized [RAMADDA](https://ramadda.org) server.


<a id="h-440D6E11"></a>

## Introduction

This repository contains files necessary to build and run a RAMADDA Docker container. The RAMADDA Docker images associated with this repository are [available on DockerHub](https://hub.docker.com/r/unidata/ramadda-docker/).


<a id="h-2B7ACAE3"></a>

### Quickstart

```sh
docker run -d -p 80:8080 unidata/ramadda-docker:latest
```


<a id="h-833DC148"></a>

## Versions

From now on, only the "latest" version of RAMADDA will be maintained in ramadda-docker, due to its frequent updates, sometimes occurring daily. This "latest" version will be updated in conjunction with any new releases of the upstream Tomcat images.

We strive to maintain the security of this project's DockerHub images by updating them with the latest upstream improvements. If you have any concerns in this area, please email us at [security@unidata.ucar.edu](mailto:security@unidata.ucar.edu) to bring them to our attention.


<a id="h-23902167"></a>

## Prerequisites

Before you begin using this Docker container project, make sure your system has Docker installed. Docker Compose is optional but recommended.


<a id="h-4DC46B26"></a>

## Installation

You can either pull the image from DockerHub with:

```sh
docker pull unidata/ramadda-docker:latest
```

Or you can build it yourself with:

1.  ****Clone the repository****: `git clone https://github.com/Unidata/ramadda-docker.git`
2.  ****Navigate to the project directory****: `cd ramadda-docker`
3.  ****Build the Docker image****: `docker build -t ramadda-docker:latest` .


<a id="h-232B8397"></a>

## Usage


<a id="h-A19AC365"></a>

### Memory

Tomcat web applications and RAMADDA can require large amounts of memory to run. This container is setup to run Tomcat with a default [4 gigabyte memory allocation](files/javaopts.sh). When running this container, ensure your VM or hardware can accommodate this memory requirement.


<a id="h-31327E59"></a>

### Docker compose

To run the RAMADDA Docker container, beyond a basic Docker setup, we recommend installing [docker-compose](https://docs.docker.com/compose/). However, `docker-compose` use is not mandatory. There is an example [docker-compose.yml](https://github.com/Unidata/ramadda-docker/blob/master/docker-compose.yml) in this repository.


<a id="h-B6696F84"></a>

#### Running RAMADDA

Once you have completed your setup you can run the container with:

```sh
docker-compose up -d
```

The output of such command should be something like:

```
Creating ramadda
```


<a id="h-4F5F0E81"></a>

#### Stopping RAMADDA

To stop this container:

```sh
docker-compose stop
```


<a id="h-105EE424"></a>

#### Delete RAMADDA Container

To clean the slate and remove the container (not the image, the container):

```sh
docker-compose rm -f
```


<a id="h-1D163FA5"></a>

### RAMADDA


<a id="h-FA04ED59"></a>

#### Create RAMADDA Directories

Create the local directories defined in the docker-compose.yml for the RAMADDA `/data/repository` and `/data/repository/logs` directories, and the Tomcat `/usr/local/tomcat/logs` directory. For example:

```sh
mkdir repository tomcat-logs ramadda-logs
```


<a id="h-A3E47BAB"></a>

#### RAMADDA pw.properties File

Inside the `repository` directory, create the `pw.properties` file. The contents of this `.properties` file will look something like:

```sh
ramadda.install.password=mysecretpassword
```

Replace mysecretpassword with the password of your choosing.


<a id="h-3A7881FD"></a>

### Upgrading

Upgrading to the latest version of the image is easy. Simply stop the container via `docker` or `docker-compose`, followed by

```sh
docker pull unidata/ramadda-docker:latest
```

and restart the container.


<a id="h-7A9DACE9"></a>

### Check What is Running


<a id="h-004CE742"></a>

#### curl

At this point you should be able to do:

```sh
curl localhost:80/repository
# or whatever port you mapped to outside the container in the docker-compose.yml
```

and get back a response that looks something like

```
<!DOCTYPE html>
<html>
<head><title>Installation</title>
...
</html>
```


<a id="h-B3CF66F2"></a>

#### docker ps

If you encounter a problem there, you can also:

```sh
docker ps
```

which should give you output that looks something like this:

```
CONTAINER ID IMAGE                  COMMAND                CREATED      STATUS     PORTS                                   NAMES
7d7f65b66f8e unidata/ramadda-docker:latest "/bin/sh -c ${CATALIN" 21 hours ago Up 21 hours 8080/tcp, 0.0.0.0:80->8080/tcp ramaddadocker_ramadda_1
```

to obtain the ID of the running RAMADDA container. You can enter the container with:

```sh
docker exec -it <ID> bash
```

Use `curl` **inside** the container to verify RAMADDA is running:

```sh
curl localhost:8080/repository
```

you should get a response that looks something like:

```
<!DOCTYPE html>
<html>
<head><title>Installation</title>
...
</html>
```


<a id="h-7781CDC8"></a>

## Configuration


<a id="h-16477010"></a>

### Docker compose


<a id="h-475FD8D0"></a>

#### Basic

Define directory and file paths for log files, Tomcat, RAMADDA, and data in [docker-compose.yml](https://github.com/Unidata/ramadda-docker/blob/master/docker-compose.yml).


<a id="h-442C5DE6"></a>

### Tomcat

RAMADDA container is based off of the [canonical Tomcat container](https://hub.docker.com/_/tomcat/) with [some additional security hardening measures](https://hub.docker.com/r/unidata/tomcat-docker/). Tomcat configuration can be done by mounting over the appropriate directories in `CATALINA_HOME` (`/usr/local/tomcat`).


<a id="h-F0219C98"></a>

### Java Configuration Options

The Java configuration options (`JAVA_OPTS`) are configured in `${CATALINA_HOME}/bin/javaopts.sh` (see [javaopts.sh](files/javaopts.sh)) inside the container. Note this file is copied inside the container during the Docker build. See the `docker-compose` section above for configuring some of the environment variables of this file.


<a id="h-15BF48EB"></a>

### Configurable Tomcat UID and GID

[See parent container](https://github.com/Unidata/tomcat-docker#configurable-tomcat-uid-and-gid).


<a id="h-BAD3F95E"></a>

### HTTP Over SSL

Please see Tomcat [parent container repository](https://github.com/Unidata/tomcat-docker#http-over-ssl) for HTTP over SSL instructions.


<a id="h-4585A68C"></a>

## Support

If you have a question or would like support for this RAMADDA Docker container, consider [submitting a GitHub issue](https://github.com/Unidata/thredds-docker/issues).
