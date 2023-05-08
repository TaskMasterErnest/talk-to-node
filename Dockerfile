FROM eclipse-temurin:17-jdk

EXPOSE 8080

ARG JAR_FILE=target/*.jar

# create a group and add a user to that group
RUN addgroup -S jenkins-pipeline && adduser -S taskmaster -G jenkins-pipeline

#use COPY instead of ADD; COPY jar file into homedir of user
COPY ${JAR_FILE} /home/taskmaster/app.jar

#activate the user
USER taskmaster

ENTRYPOINT ["java","-jar","/home/taskmaster/app.jar"]