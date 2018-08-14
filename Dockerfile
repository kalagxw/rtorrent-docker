FROM kalagxw/ubuntu-sshd
USER root

RUN apt-get update  && apt-get install -y git build-essential automake libcppunit-dev libtool zlib1g-dev gawk libsigc++-2.0-dev libssl-dev libncurses5-dev libncursesw5-dev libcurl4-openssl-dev libxmlrpc-c++8-dev unzip \
                   && git clone https://github.com/rakshasa/libtorrent && cd libtorrent/ && ./autogen.sh && ./configure && make -j$(nproc) \
                   && make install && cd /root && ldconfig \
                   && git clone https://github.com/rakshasa/rtorrent && cd rtorrent && ./autogen.sh \
                   && ./configure --with-xmlrpc-c --with-ncurses --enable-ipv6 && make -j$(nproc) \
                   && make install
RUN cd /root && export DEBIAN_FRONTEND=noninteractive && apt-get install -y wget nginx-full php-fpm php7.2-cgi php7.2-cli php-geoip curl ffmpeg mediainfo unrar rar sox libsox-fmt-mp3 \
                   && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata \
                   && apt-get install -y libgd-dev libxslt-dev libgeoip-dev \
                   && apt-get autoremove -y nginx-full \
                   && git clone https://github.com/hakasenyang/openssl-patch.git openssl-patch && git clone https://github.com/kn007/patch.git nginx-patch \
                   && wget -O nginx-ct.zip -c https://github.com/grahamedgecombe/nginx-ct/archive/v1.3.2.zip && unzip nginx-ct.zip \
                   && git clone https://github.com/google/ngx_brotli.git && cd ngx_brotli && git submodule update --init && cd ../ \
                   && git clone https://github.com/openssl/openssl.git && cd openssl && patch -p1 < ../openssl-patch/openssl-equal-pre9_ciphers.patch \
                   && wget -c https://nginx.org/download/nginx-1.14.0.tar.gz && tar zxf nginx-1.14.0.tar.gz && cd nginx-1.14.0/  && patch -p1 < ../nginx-patch/nginx.patch && patch -p1 < ../nginx-patch/fix_nginx_hpack_push_error.patch && patch -p1 < ../nginx-patch/nginx_auto_using_PRIORITIZE_CHACHA.patch \
                   && ./configure --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_v2_hpack_enc --with-http_spdy_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_xslt_module=dynamic --with-stream=dynamic --with-stream_ssl_module --with-mail=dynamic --with-mail_ssl_module --add-module=../ngx_brotli --add-module=../nginx-ct-1.3.2 --with-openssl=../openssl --with-openssl-opt=enable-tls1_3 --with-http_ssl_module --with-http_gzip_static_module \
                   && make -j$(nproc) && make install \
                   && cd / && find . -name "*.old" -exec rm -f {} \; && cd ~
                   
RUN git clone https://github.com/kalagxw/rtorrent-docker.git a && cp ./a/rutorrent.conf /etc/nginx/sites-enabled/888-rutorrent \
                   && rm /etc/php/7.2/fpm/pool.d/www.conf && cp ./a/phpfpmwww /etc/php/7.2/fpm/pool.d/www.conf \
&& rm /etc/php/7.2/fpm/php.ini && cp ./a/phpini /etc/php/7.2/fpm/php.ini \
                   && git clone https://github.com/Novik/ruTorrent.git /var/www/rt \
                   && cp ./a/pwd /etc/nginx/htpasswd && chown www-data -R /var/www/rt/share \
&& cp ./a/rtorrentrc /root/.rtorrent.rc \
                   && mkdir -p /pt/Downloads/ && mkdir -p /pt/rtorrent/.sessions/ && mkdir -p /pt/rtorrent/torrents/ && mkdir -p /pt/rtorrent/incoming/ \
                   && chown -R www-data /pt \
&& rm /var/www/rt/plugins/spectrogram/conf.php && cp ./a/1.php /var/www/rt/plugins/spectrogram/conf.php \
                   && rm /var/www/rt/conf/config.php && cp ./a/2.php /var/www/rt/conf/config.php
                   
RUN ln -s /usr/share/nginx/sbin/nginx /usr/sbin/nginx && mkdir -p /var/lib/nginx/body && mkdir -p /run/php/ && touch /run/php/php7.2-fpm.pid

EXPOSE 80

                   
