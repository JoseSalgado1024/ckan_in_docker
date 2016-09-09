FROM eccenca/baseimage:1.0.1
MAINTAINER Jose A. Salagdo<jose.salgado.wrk@gmail.com>

RUN apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive=apt-get -qqy update && apt-get -q -y install default-jre-headless

ENV SOLR_HOME /opt/solr/example/solr
ENV SOLR_VERSION 4.10.4
ENV SOLR solr-$SOLR_VERSION
ENV CKAN_VERSION 2.2.3

RUN mkdir -p /opt/solr
ADD ./requirements/schema.xml /opt/solr/schema.xml
# ADD http://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz /opt/$SOLR.tgz
#RUN tar zxf /opt/$SOLR.tgz -C /opt/solr --strip-components 1

RUN cp -R $SOLR_HOME/collection1/ $SOLR_HOME/ckan/
RUN echo name=ckan > $SOLR_HOME/ckan/core.properties

ADD https://github.com/ckan/ckan/raw/ckan-$CKAN_VERSION/ckan/config/solr/schema.xml $SOLR_HOME/ckan/conf/schema.xml

EXPOSE 8983
WORKDIR /opt/solr/example
CMD ["java", "-jar", "start.jar"]
