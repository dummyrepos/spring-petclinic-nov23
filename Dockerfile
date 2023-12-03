FROM maven:3-jdk-8 as mvn
RUN git clone https://github.com/spring-projects/spring-petclinic.git
RUN cd spring-petclinic && mvn package

FROM amazoncorretto:17-alpine-jdk
LABEL AUTHOR="khaja"
COPY --from=mvn /spring-petclinic/target/spring-petclinic*.jar /spring-petclinic.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar"]
CMD ["/spring-petclinic.jar"]