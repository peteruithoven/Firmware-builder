FROM ubuntu

RUN apt-get update &&\
    apt-get install -y sudo unzip python wget nano bzip2 patch lib32z1 lib32ncurses5 lib32bz2-1.0 libc6-i386 python-colorama &&\
    apt-get clean

RUN mkdir /gcc-arm && \
    cd /gcc-arm && \
    wget --no-check-certificate https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q3-update/+download/gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2 -O - | tar -xj

# copy build script into container
COPY build.sh /home/
RUN chmod +x /home/build.sh

CMD ["/home/build.sh"]
