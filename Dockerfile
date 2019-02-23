FROM kalagxw/ubuntu-sshd
RUN apt-get install -y git-core dnsutils iputils-ping net-tools
RUN apt-get install -y software-properties-common && add-apt-repository ppa:ondrej/nginx-mainline && add-apt-repository ppa:ondrej/nginx-qa \
&& add-apt-repository ppa:libtorrent.org/rc-1.1-daily && apt-get update && apt-get upgrade -y openssl
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y wget nginx-full php-fpm php7.2-cgi php7.2-cli php-geoip curl ffmpeg mediainfo unrar rar sox libsox-fmt-mp3 \
                   && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata                 
RUN git clone https://github.com/kalagxw/rtorrent-docker.git a && cp ./a/rutorrent.conf /etc/nginx/sites-enabled/888-rutorrent \
                   && rm /etc/php/7.2/fpm/pool.d/www.conf && cp ./a/phpfpmwww /etc/php/7.2/fpm/pool.d/www.conf \
&& rm /etc/php/7.2/fpm/php.ini && cp ./a/phpini /etc/php/7.2/fpm/php.ini \
                   && git clone https://github.com/Novik/ruTorrent.git /var/www/rt \
                   && cp ./a/pwd /etc/nginx/htpasswd && chown www-data -R /var/www/rt/share \
&& cp ./a/rtorrentrc /root/.rtorrent.rc \
&& mkdir /etc/v2ray -p && cp ./a/1 /etc/v2ray/v2ray.crt && cp ./a/k /etc/v2ray/v2ray.key \
&& cp ./a/tls /etc/nginx/sites-enabled/tls && cp ./a/ssjson /root/shadowsocks-libev.json && cp ./a/v2json /root/v2ray.json \
                   && mkdir -p /pt/Downloads/ && mkdir -p /pt/rtorrent/.sessions/ && mkdir -p /pt/rtorrent/torrents/ && mkdir -p /pt/rtorrent/incoming/ \
                   && chown -R www-data /pt \
&& rm /var/www/rt/plugins/spectrogram/conf.php && cp ./a/1.php /var/www/rt/plugins/spectrogram/conf.php \
                   && rm /var/www/rt/conf/config.php && cp ./a/2.php /var/www/rt/conf/config.php
RUN rm -rf /etc/nginx/sites-enabled/default \
    && rm -rf /etc/nginx/nginx.conf && cp ./a/nginxconf /etc/nginx/nginx.conf && cp ./a/bbr.sh /root/bbr.sh
    
EXPOSE 80

                   
