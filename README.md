# S2I with Apache Tomcat 7, Java 7 and Apache Ant 1.9

S2I Image Builder for building with Maven2 and running Java 7 applications on Tomcat 7.

Before Start
---
Download JDK 7 and put in `java-installer` directory

Local Docker build
---
```bash
$ cd s2i-tomcat7-java7-ant19
$ docker build -t h3nrique/s2i-tomcat7-java7-ant19:latest .
```

Local Test
---
```bash
$ s2i build https://github.com/h3nrique/systemprops.git h3nrique/s2i-tomcat7-java7-ant19:latest demoapp -e WAR_NAME=systemprops.war
$ docker run -p 8080:8080 demoapp
```

Deploy Builder on Openshift
---
```bash
$ oc new-build "centos/s2i-base-centos7:1~https://github.com/h3nrique/s2i-tomcat7-java7-ant19.git" --name=s2i-tomcat7-java7-ant19 --strategy=docker
```

Deploy APp on Openshift
---
```bash
$ oc new-app "s2i-tomcat7-java7-ant19:latest~https://github.com/h3nrique/systemprops.git" --name=systemprops -l app=systemprops
```
