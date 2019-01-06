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
		unzip && apt-get purge

RUN mkdir /build
WORKDIR /build
ADD build.sh /build/build.sh
RUN /build/build.sh

FROM ubuntu:bionic
RUN apt-get update && apt-get install -y libssl1.0.0 libssl1.1 libpcre3 zlib1g && apt-get purge

COPY --from=0 /usr/sbin/nginx /usr/sbin/nginx
COPY --from=0 /etc/nginx/mime.types /etc/nginx/mime.types

RUN mkdir -p \
	/etc/nginx/conf.d \
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
	/etc/nginx/conf.d/

ADD nginx.conf /etc/nginx/nginx.conf

# Epic requires custom TLS certificates and for your connecting PCs
# to have trusted your custom CA. Only enable this if you know what
# you're doing :)
# ADD epic.conf
# Ideally, do not put these keys in your image. Instead, mount them
# a volume.
# ADD ca/client.key ca/client.pem /etc/nginx/

CMD nginx -g "daemon off;" -c /etc/nginx/nginx.conf
VOLUME ["/cache", "/var/log/nginx"]
