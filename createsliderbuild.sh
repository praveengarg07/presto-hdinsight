#!/bin/bash
set -eux

VERSION=$1
rm -rf build
mkdir build
cd build

wget https://github.com/prestodb/presto-yarn/archive/master.tar.gz -O presto-yarn.tar.gz
tar xzf presto-yarn.tar.gz
mvn -Dpresto.version=$VERSION clean package -f presto-yarn-master/pom.xml
unzip presto-yarn-master/presto-yarn-package/target/presto-yarn-package-*.zip -d presto-yarn-package
tar xzf presto-yarn-package/package/files/presto-server-*.tar.gz

cp /usr/hdp/current/hadoop-client/hadoop-azure-*.jar  presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-client/lib/jetty-util-*.hwx.jar  presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-client/lib/azure-storage-*.jar presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-client/lib/hadoop-lzo*.jar presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-client/hadoop-common*.jar presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-client/lib/jackson*.jar presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-client/azure-*.jar presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-client/lib/commons-lang-2.6.jar presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-client/client/okio.jar presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-hdfs-client/lib/adls2-oauth2-token-provider.jar presto-server-*/plugin/hive-hadoop2/
cp /usr/hdp/current/hadoop-mapreduce-client/wildfly*.jar presto-server-*/plugin/hive-hadoop2/

rm -rf presto-server-*/plugin/hive-hadoop2/jackson-databind-2.7.8.jar


mkdir -p presto-server-$VERSION/plugin/event-logger

wget https://github.com/praveengarg07/presto-event-logger/archive/master.tar.gz -O presto-event-logger.tar.gz
tar xzf presto-event-logger.tar.gz
mvn package -f presto-event-logger-master/pom.xml
cp presto-event-logger-master/target/presto-event-logger*.jar presto-server-*/plugin/event-logger/

wget https://github.com/praveengarg07/presto-hadoop-apache2/archive/master.tar.gz -O presto-hadoop-apache2.tar.gz
tar xzf presto-hadoop-apache2.tar.gz
mvn package -f presto-hadoop-apache2-master/pom.xml
cp presto-hadoop-apache2-master/target/hadoop-apache2-2.7.4-5.jar presto-server-*/plugin/hive-hadoop2/



cp /usr/hdp/current/hadoop-client/lib/{microsoft-log4j-etwappender-*.jar,mdsdclient-*.jar,json-simple-*.jar,slf4j-api-*.jar,slf4j-log4j12-*.jar,guava-*.jar,log4j-*.jar} presto-server-*/plugin/event-logger/

tar czf presto-server-$VERSION.tar.gz presto-server-*/
rm presto-yarn-package/package/files/presto-server*.tar.gz
cp presto-server-*.tar.gz presto-yarn-package/package/files/
cd presto-yarn-package
zip -r ../presto-yarn-package.zip .
cd ..
