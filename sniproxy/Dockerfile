FROM ubuntu:bionic

# Improve build times by sharing this step with the other container
RUN apt-get update && apt-get install -y libev4 libudns0 && apt-get purge
RUN apt-get update && apt-get install -y git build-essential libudns-dev libpcre3 libpcre3-dev libev-dev devscripts automake libtool autoconf autotools-dev cdbs debhelper dh-autoreconf dpkg-dev gettext  pkg-config fakeroot

RUN git clone https://github.com/dlundquist/sniproxy.git 
WORKDIR /sniproxy
RUN ./autogen.sh && ./configure && make



FROM ubuntu:bionic
RUN apt-get update && apt-get install -y libev4 libudns0 && apt-get purge
COPY --from=0  /sniproxy/src/sniproxy /usr/local/bin/sniproxy
ADD sniproxy.conf /etc/sniproxy.conf
CMD sniproxy -f
