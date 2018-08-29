#!/bin/bash

wget https://github.com/chobits/ngx_http_proxy_connect_module/archive/master.zip
unzip master.zip
wget http://nginx.org/download/nginx-1.15.2.tar.gz
tar -xf nginx*
cd nginx*

patch -p1 < ../ngx_http_proxy_connect_module-master/patch/proxy_connect_rewrite_1015.patch

# Configure options taken from the current Ubuntu 12.04 `nginx-light` rules
# with the addition of the slice module, and the removal of a no-longer-valid one
./configure  \
            --prefix=/usr \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-client-body-temp-path=/var/lib/nginx/body \
            --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
            --http-log-path=/var/log/nginx/access.log \
            --http-proxy-temp-path=/var/lib/nginx/proxy \
            --lock-path=/var/lock/nginx.lock \
            --pid-path=/var/run/nginx.pid \
            --with-http_gzip_static_module \
            --with-http_ssl_module \
            --with-ipv6 \
            --without-http_browser_module \
            --without-http_geo_module \
            --without-http_limit_req_module \
            --without-http_memcached_module \
            --without-http_referer_module \
            --without-http_scgi_module \
            --without-http_split_clients_module \
            --with-http_stub_status_module \
            --without-http_ssi_module \
            --without-http_userid_module \
            --without-http_uwsgi_module \
            --with-http_slice_module \
            --add-module=/build/ngx_http_proxy_connect_module-master


make -j 8 
make install
