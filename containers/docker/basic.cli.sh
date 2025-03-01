#1. Search image redis from dockerhub & harbor
# From DockerHub
docker search redis
# From Harbor
skopeo list-tags docker://registry.adinusa.id/btacademy/redis

#2. Running image redis
docker run registry.adinusa.id/btacademy/redis  # CTRL + c for quit
docker run -d registry.adinusa.id/btacademy/redis  # Running in background (Background)
docker run -d --name redis1 registry.adinusa.id/btacademy/redis # Giving the container a name

#3. Display running container.
docker ps 
docker container ls

#4. Display all docker container.
docker ps -a
docker container ls -a

#5. Display container description .
# docker inspect CONTAINER_NAME/CONTAINER_ID
docker inspect redis1

#6. Display content of the logs in container.
# docker logs CONTAINER_NAME/CONTAINER_ID
docker logs redis1

#7. Display live stream resource used in container.
# docker stats CONTAINER_NAME/CONTAINER_ID
docker stats redis1

#8. Display running process in container.
# docker top CONTAINER_NAME/CONTAINER_ID
docker top redis1

#9. Shutdown the container.
# docker stop CONTAINER_NAME/CONTAINER_ID
docker stop redis1