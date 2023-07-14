Jenkins Docker images

```
docker run -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 --restart=on-failure jenkins/jenkins:lts-jdk11
```

```
docker volume ls
docker container ls
docker logs 7318f678da86
# collect e69cf8499b964072ae30e895d10b7bf0
```

