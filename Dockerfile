
FROM tomcat:10.1-jdk21-temurin


COPY src/main/webapp/ /usr/local/tomcat/webapps/ROOT/


COPY build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

RUN rm -rf /usr/local/tomcat/webapps/*


COPY CodeQuest.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
EXPOSE 8080

CMD ["catalina.sh", "run"]
