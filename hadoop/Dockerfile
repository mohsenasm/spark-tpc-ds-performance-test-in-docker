# for tpc-ds
FROM alpine/git as git
WORKDIR /root
RUN git clone https://github.com/IBM/spark-tpc-ds-performance-test

# for hadoop and hive
FROM cdecl/hadoop-hive:2.6.0
RUN echo "export HADOOP_HOME=/usr/local/hadoop" >> /root/.bashrc && \
    echo "export HIVE_HOME=/usr/local/hive" >> /root/.bashrc && \
    echo "export PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/hive/bin" >> /root/.bashrc
ADD start.sh /etc

# for python3 + pip + pip3
RUN apt-get update && apt-get install -y python-pip && apt-get install -y python3-pip && rm -rf /var/lib/apt/lists/*

# install nano for development
RUN apt-get update && apt-get install -y nano less && rm -rf /var/lib/apt/lists/*
RUN echo "alias l='ls -CF'" >> /root/.bashrc && \
    echo "alias ll='ls -alF'" >> /root/.bashrc

# install spark
RUN wget http://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz && \
    tar zxvf spark-2.4.0-bin-hadoop2.7.tgz && \
    rm spark-2.4.0-bin-hadoop2.7.tgz && \
    mv spark-2.4.0-bin-hadoop2.7 /usr/local/spark && \
    echo "export PATH=$PATH:/usr/local/spark/bin:/usr/local/spark/sbin" >> /root/.bashrc && \
    echo "export SPARK_HOME=/usr/local/spark" >> /root/.bashrc

# config spark
RUN mkdir /tmp/spark-events && echo '\
spark.eventLog.enabled          true \n\
spark.eventLog.dir              /tmp/spark-events \n\
spark.history.fs.logDirectory   /tmp/spark-events \n\
spark.master    yarn' > /usr/local/spark/conf/spark-defaults.conf && echo '\
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \n\
export SPARK_MASTER_IP=$SPARK_IP_ADDRESS' >> /usr/local/spark/conf/spark-env.sh


# copy TPC-DS performance test
COPY --from=git /root/spark-tpc-ds-performance-test /root/spark-tpc-ds-performance-test
COPY tpcdsenv.sh /root/spark-tpc-ds-performance-test/bin/tpcdsenv.sh

ENTRYPOINT []
