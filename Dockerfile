FROM ubuntu:bionic

# shared layers with second stage image, faster build by caching layers!
RUN apt-get update && apt-get install -y libssl1.0.0 libpcre3 zlib1g && apt-get purge

RUN apt-get update && \
	apt-get install -y \
		build-essential \
		libssl-dev \
		libpcre3-dev \
		zlib1g-dev \
		wget \
                openssl \
		unzip && apt-get purge

RUN mkdir /build
WORKDIR /build
ADD build.sh /build/build.sh
RUN /build/build.sh

# Generate a fake CA + certs for epic games so that we can put some fake certificates in to the image
# so that the epic games config file can be loaded without error
RUN \
   openssl genrsa -out rootca.key 2048 && \
   openssl req -batch -x509 -new -nodes -key rootca.key -sha256 -days 10000 -out rootca.pem && \
   openssl genrsa -out client.key 2048 && \
   cat /etc/ssl/openssl.cnf > /build/openssl.conf && \
   echo "[SAN]" >> /build/openssl.conf && \
   echo "subjectAltName=DNS:download1.epicgames.com,DNS:download2.epicgames.com,DNS:download3.epicgames.com,DNS:download4.epicgames.com,DNS:cdn1.epicgames.com,DNS:cdn2.epicgames.com,DNS:cdn1.unrealengine.com,DNS:cdn2.unrealengine.com,DNS:cdn3.unrealengine.com,DNS:static-assets-prod.epicgames.com,DNS:epicgames-download1.akamaized.net" >> /build/openssl.conf && \
   openssl req -new -key client.key -out client.csr -subj "/C=US/ST=CA/O=Acme, Inc./CN=download.epicgames.com" -reqexts SAN -config /build/openssl.conf -out client.csr && \
   openssl x509 -req -in client.csr -CA rootca.pem  -CAkey rootca.key  -CAcreateserial -out client.pem -days 10000 -sha256

FROM ubuntu:bionic
RUN apt-get update && apt-get install -y libssl1.0.0 libssl1.1 libpcre3 zlib1g && apt-get purge

COPY --from=0 /usr/sbin/nginx /usr/sbin/nginx
COPY --from=0 /etc/nginx/mime.types /etc/nginx/mime.types

RUN mkdir -p \
	/etc/nginx/conf.d \
        /etc/nginx/ssl/epic \
	/var/lib/nginx/body \
	/var/lib/nginx/fastcgi \
	/cache/cache_data \
	/cache/static \
	/var/log/nginx


ADD \
	origin.conf \
	steam.conf \
	blizzard.conf \
	league.conf \
	wargaming.conf \
	sony.conf \
	microsoft.conf \
	hirez.conf \
	catch_all.conf \
	static.conf \
        uplay.conf \
        epic.conf \
	/etc/nginx/conf.d/

ADD nginx.conf /etc/nginx/nginx.conf

# Epic games fake CA to allow epic config file to be loaded
COPY --from=0 /build/client.key /build/client.pem /etc/nginx/ssl/epic/

CMD nginx -g "daemon off;" -c /etc/nginx/nginx.conf
VOLUME ["/cache", "/var/log/nginx"]
