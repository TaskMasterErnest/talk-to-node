FROM eclipse-temurin:11-jdk

EXPOSE 8080

ARG JAR_FILE=target/*.jar

# create a group and add a user to that group
RUN groupadd -r jenkins-pipeline && useradd -r -g jenkins-pipeline taskmaster

#use COPY instead of ADD; COPY jar file into homedir of user
COPY ${JAR_FILE} /home/taskmaster/app.jar

#activate the user
USER taskmaster

ENTRYPOINT ["java","-jar","/home/taskmaster/app.jar"]