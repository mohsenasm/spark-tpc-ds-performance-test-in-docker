FROM alpine/git as git
WORKDIR /root
RUN git clone https://github.com/IBM/spark-tpc-ds-performance-test

# for scala
FROM hseeberger/scala-sbt

# for python3 + pip + pip3
RUN apt-get update && apt-get install -y python-pip && apt-get install -y python3-pip

# install spark
RUN wget http://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz && \
    tar zxvf spark-2.4.0-bin-hadoop2.7.tgz
RUN rm spark-2.4.0-bin-hadoop2.7.tgz && \
    mv spark-2.4.0-bin-hadoop2.7 /usr/local/spark && \
    echo "export PATH=$PATH:/usr/local/spark/bin" >> /root/.bashrc && \
    echo "export SPARK_HOME=/usr/local/spark" >> /root/.bashrc

# copy TPC-DS performance test
COPY --from=git /root/spark-tpc-ds-performance-test /root/spark-tpc-ds-performance-test
COPY tpcdsenv.sh /root/spark-tpc-ds-performance-test/bin/tpcdsenv.sh