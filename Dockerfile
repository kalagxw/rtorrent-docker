FROM kalagxw/ubuntu-sshd
USER root

RUN apt-get update  && apt-get install -y git build-essential automake libcppunit-dev libtool zlib1g-dev gawk libsigc++-2.0-dev libssl-dev libncurses5-dev libncursesw5-dev libcurl4-openssl-dev libxmlrpc-c++8-dev unzip \
                   && git clone https://github.com/rakshasa/libtorrent && cd libtorrent/ && ./autogen.sh && ./configure && make -j$(nproc) \
                   && make install && cd /root && ldconfig \
                   && git clone https://github.com/rakshasa/rtorrent && cd rtorrent && ./autogen.sh \
                   && ./configure --with-xmlrpc-c --with-ncurses --enable-ipv6 && make -j$(nproc) \
                   && make install && cd /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y wget nginx-full php-fpm php7.2-cgi php7.2-cli php-geoip curl ffmpeg mediainfo unrar rar sox libsox-fmt-mp3 \
                   && apt-get install -y libgd-dev libxslt-dev libgeoip-dev \
                   && apt-get autoremove -y nginx-full && wget http://173.193.105.237:30068/1.zip && unzip 1.zip && cd tls && cd nginx-1.14.0 && make install \ 
                   && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
RUN rm /etc/nginx/sites-enabled/default && cp ./rutorrent.conf /etc/nginx/sites-enabled/888-rutorrent \
                   && rm /etc/php/7.2/fpm/pool.d/www.conf && cp ./phpfpmwww /etc/php/7.2/fpm/pool.d/www.conf \
                   && rm /etc/php/7.2/fpm/php.ini && cp ./phpini /etc/php/7.2/fpm/php.ini \
                   && git clone https://github.com/Novik/ruTorrent.git /var/www/rt \
                   && cp ./pwd /etc/nginx/htpasswd && chown www-data -R /var/www/rt/share \ 
                   && cp ./rtorrentrc /root/.rtorrent.rc \
                   && mkdir -p /pt/Downloads && mkdir -p /pt/rtorrent/.sessions && mkdir -p /pt/rtorrent/torrents/ && mkdir -p /pt/rtorrent/incoming \
                   && chown -R www-data /pt \
                   && rm /var/www/rt/plugins/spectrogram/conf.php && cp ./1.php /var/www/rt/plugins/spectrogram/conf.php \
                   && rm /var/www/rt/conf/config.php && cp ./2.php /var/www/rt/conf/config.php
EXPOSE 80

                   
