#################################################################

# Dockerfile
# To build. cd to directory
# docker build -t bowtie1v1.2.3 .
#################################################################

FROM ubuntu:18.04 as builder

MAINTAINER Modupeore Adetunji "madetunj@stjude.org"

### Base Image

USER root

#install java
RUN apt-get update
RUN apt-get --yes install build-essential openjdk-11-jdk-headless unzip wget zlib1g-dev
RUN rm -rf /var/lib/apt/lists/*



# #install samtools
ENV SAMTOOLS_VERSION 1.9
RUN cd /tmp && wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2; \
    tar xf samtools-${SAMTOOLS_VERSION}.tar.bz2; \
    cd samtools-${SAMTOOLS_VERSION}; \
    ./configure \
    --prefix /usr/local --disable-bz2 --disable-lzma --without-curses \
    && make -j $(nproc) && make install && \
    rm -rf samtools-${SAMTOOLS_VERSION}*

#install python
FROM r-base:3.4.1
RUN apt-get update && apt-get install -y python3 nodejs python3-numpy python3-scipy
RUN cp /usr/bin/python3 /usr/bin/python

#install java
RUN apt-get update
RUN apt-get --yes install build-essential openjdk-11-jdk-headless unzip wget zlib1g-dev
RUN rm -rf /var/lib/apt/lists/*

ENV BOWTIE_VERSION 1.2.3
ENV BOWTIE_NAME bowtie
ENV BOWTIE_URL "https://github.com/BenLangmead/bowtie/archive/v${BOWTIE_VERSION}.zip"

### First installing libtbb, python then Bowtie

RUN cd /tmp && apt-get update
RUN cd /tmp && apt-get install -y libtbb-dev && \
    wget $BOWTIE_URL && unzip v${BOWTIE_VERSION}.zip && \
    cd ${BOWTIE_NAME}-${BOWTIE_VERSION} && \
    make && make install 

#install bedtools
ENV BEDTOOLS_VERSION 2.25.0
ENV BEDTOOLS_URL "https://github.com/arq5x/bedtools2/releases/download/v${BEDTOOLS_VERSION}/bedtools-${BEDTOOLS_VERSION}.tar.gz"
RUN cd /tmp && wget $BEDTOOLS_URL; \
    tar -zxf bedtools-${BEDTOOLS_VERSION}.tar.gz; \
    cd bedtools2; \
    make && make install

COPY --from=builder /usr/local/bin/samtools /usr/local/bin/samtools
#COPY --from=bowtie /usr/bin/* /usr/bin/
#COPY --from=python /usr/local/bin/python /usr/local/bin/python
#COPY --from=bowtie /usr/bin/bowtie /usr/local/bin/bowtie
#CMD ["bowtie"]

