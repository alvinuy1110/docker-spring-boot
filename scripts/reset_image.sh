docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm
#docker rmi spring-boot:v1
docker rmi $@