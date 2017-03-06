FROM tomcat:7-jre8

ADD ./target/petclinic-0.2.war /usr/local/tomcat/webapps
EXPOSE 8080:8080

CMD ["catalina.sh", "run"]