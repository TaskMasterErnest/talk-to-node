FROM alpine:3.18.0

RUN apk add --no-cache openjdk17-jre

EXPOSE 8080

ARG JAR_FILE=target/*.jar

# create a group and add a user to that group
RUN apk add --no-cache --virtual=build-dependencies \
  shadow \
  && groupadd -r jenkins-pipeline \
  && useradd -r -g jenkins-pipeline taskmaster \
  && apk del build-dependencies
  
# use COPY instead of ADD; COPY jar file into homedir of user
COPY ${JAR_FILE} /home/taskmaster/app.jar

# activate the user
USER taskmaster

ENTRYPOINT ["java","-jar","/home/taskmaster/app.jar"]