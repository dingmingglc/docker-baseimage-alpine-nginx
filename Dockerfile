FROM ghcr.io/linuxserver/baseimage-alpine:3.13

# install packages
RUN \
 echo "**** install build packages ****" && \ 
 apk update && \
 echo "**** docker-webdav-alpine  download and complile nginx ****" && \
 CONFIG=" \
--prefix=/etc/nginx \
--with-http_dav_module --add-module=/tmp/nginx-dav-ext-module-master \
--sbin-path=/usr/sbin/nginx \
--modules-path=/usr/lib/nginx/modules \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--user=nginx \
--group=nginx \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_auth_request_module \
--with-http_xslt_module=dynamic \
--with-http_image_filter_module=dynamic \
--with-http_geoip_module=dynamic \
--with-threads \
--with-stream \
--with-stream_ssl_module \
--with-stream_ssl_preread_module \
--with-stream_realip_module \
--with-stream_geoip_module=dynamic \
--with-http_slice_module \
--with-compat \
--with-file-aio \
--with-http_v2_module \
" && \
apk add --no-cache pcre libxml2 libxslt && \
apk add --no-cache apache2-utils && \
apk add --no-cache gcc make libc-dev openssl-dev  pcre-dev zlib-dev libxml2-dev libxslt-dev linux-headers gnupg1 gd-dev  geoip-dev  expat-dev && \
cd /tmp && \
wget https://github.com/nginx/nginx/archive/master.zip -O nginx.zip && \
unzip nginx.zip && \
wget https://github.com/arut/nginx-dav-ext-module/archive/master.zip -O dav-ext-module.zip && \
unzip dav-ext-module.zip && \
cd nginx-master && \
./auto/configure $CONFIG && \
make && make install && \
cd /root && \
apk del gcc make libc-dev pcre-dev zlib-dev libxml2-dev libxslt-dev expat-dev geoip-dev gd-dev openssl-dev  && \
rm -rf /var/cache/apk/* && \
rm -rf /tmp/* && \
echo "**** docker-baseimage-alpine-nginx ****" && \
 apk add --no-cache pcre libxml2 libxslt && \
    apk add --no-cache apache2-utils && \
    apk add --no-cache gcc make libc-dev pcre-dev zlib-dev libxml2-dev libxslt-dev && \
    cd /tmp && \
    wget https://github.com/nginx/nginx/archive/master.zip -O nginx.zip && \
    unzip nginx.zip && \
    wget https://github.com/arut/nginx-dav-ext-module/archive/master.zip -O dav-ext-module.zip && \
    unzip dav-ext-module.zip && \
    cd nginx-master && \
    ./auto/configure --prefix=/opt/nginx --with-http_dav_module --add-module=/tmp/nginx-dav-ext-module-master && \
    make && make install && \
    cd /root && \
    chmod +x /entrypoint.sh && \
    apk del gcc make libc-dev pcre-dev zlib-dev libxml2-dev libxslt-dev && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \ 
 echo "**** docker-baseimage-alpine-nginx ****" && \
 apk add --no-cache \
	apache2-utils \
	git \
	libressl3.1-libssl \
	logrotate \
	nano \
#	nginx \
	openssl \
	php7 \
	php7-fileinfo \
	php7-fpm \
	php7-json \
	php7-mbstring \
	php7-openssl \
	php7-session \
	php7-simplexml \
	php7-xml \
	php7-xmlwriter \
	php7-zlib && \
 echo "**** configure nginx ****" && \
 echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> \
	/etc/nginx/fastcgi_params && \
 rm -f /etc/nginx/conf.d/default.conf && \
 echo "**** fix logrotate ****" && \
 sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
 sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
	/etc/periodic/daily/logrotate

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
