# docker-spring-boot

This is to demonstrate how to run Spring Boot apps in a docker container

## Image naming

Name the image with format <name>:<version>

Example:
```
spring-boot:v1
```

## Building the Image

Must fetch the binary and config files and drop them in designated location.

### Directory Structure

|Directory|Description|
|---------|-----------|
|binary| copy all *.jar and rename to app.jar|
|config| copy all files |
|trust-certs| copy all certs in PEM format and add them to the truststore|

Example tree:
```
 ./
  - <binary>
  - <config>
  - <trust-certs>
  Dockerfile

```
### Docker
Example 1:
```
docker build -t spring-boot:v1 -f ./spring-boot/Dockerfile-springboot .
```

where 
 -t - tag is the name/version/label for image
 -f - specfic Dockerfile (defaults to Dockerfile)

## Publishing Image

TODO
 
## Running the Container

### Guideline

* name the container for easier reference in future docker commands

```
--name <given_name>
```
* cleanup docker images and containers as they take up space

### Examples
Example 1: Specify the image name with additional args (like spring args)
```
docker run -d -p 8080:8080 --name myapp spring-boot:v1 --spring.config.name=references-ws
```

where
 -d - run as daemon
 -p - port to bind host-to-target

Example 2: Specify the image name with additional args (like spring args) with profiles
```
docker run -d -p 8080:8080 --name myapp spring-boot:v1 --spring.config.name=references-ws \
  --spring.profiles.active=local,dev
```

Example 3: Add java opts for debugging
```
docker run -d -p 8080:8080  --name myapp \
-p 5005:5005 --env JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 \
  spring-boot:v1 --spring.config.name=references-ws
```

Example 4: Using volumes

This one assumes you have dir in your host "/home/user/git/docker-spring-boot/dir" as an example.
This will allow transfer in/out of the files

```
docker run -d -p 8080:8080 --name myapp -v /home/user/git/docker-spring-boot/dir:/app/log spring-boot:v1 --spring.config.name=references-ws
```
Note: must be an absolute path

### Verifying

```
curl -kv http://localhost:8080/mgmt/info
```

## Common Commands

### Show images
```
docker images
```

### Remove image
```
docker rmi <name>
```

### show all containers including exited
```
docker ps -a
```

### start/ stop
```
docker start/stop <name>
```
### pause/ unpause
```
docker pause/unpause <name>
```

### show the resource consumptions of the running containers
```
docker stats
```

### Remove container
```
docker rm <name> --force
```
* optional (--force)

### Login inside running container
```
docker exec -it <name> sh
```
* switch (sh) to command base on your image OS

### View logs
```
docker logs <name>
```


## Application/ Container Features

### Logging
Most of the output is via stdout/ stderr.  One can do something like:

```
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} ${JAVA_EXTRA_OPTS} -jar app.jar ${0} ${@} > ${APP_HOME}/log/stdout.txt"]
```

And then create a volume
```
docker run -d -p 8080:8080 --name myapp -v /home/user/git/docker-spring-boot/dir:/app/log spring-boot:v1 --spring.config.name=references-ws
```


## Utility Scripts

Scripts are located in scripts directory.
|Script|Description|
|------|-----------|
|remove_exited_containers.sh| Clean up lingering exited containers|
|reset_image.sh|Cleanup exited containers and remove the provided image|

###################  
## TODO

* base image
* jdk version (DONE)
* certs (DONE)

* dynatrace
* debugging
* logging ??
  -- log rotation??
* secrets

### CI

* build
* publish/ deploy
* pull



## References
* https://spring.io/guides/topicals/spring-boot-docker/
* https://blog.pavelsklenar.com/spring-boot-run-and-build-in-docker/
 