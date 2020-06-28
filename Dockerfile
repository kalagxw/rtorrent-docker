FROM kalagxw/ubuntu-sshd
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y git-core dnsutils iputils-ping net-tools flex
RUN apt-get autoremove systemd \
&& curl -sL https://deb.nodesource.com/setup_12.x | bash - \
&& apt update && apt install nodejs -y && npm -g install npm
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y --fix-missing wget nginx-common unzip mediainfo libxmlrpc-c++8-dev zlib1g-dev libmnl-dev libcurl4-openssl-dev iptables iproute2
RUN wget https://github.com/rakshasa/rtorrent/releases/download/v0.9.8/libtorrent-0.13.8.tar.gz && tar zxf libtorrent-0.13.8.tar.gz && cd libtorrent-0.13.8 && ./autogen.sh && ./configure && make && make install && ldconfig && cd .. && rm -rf libtorrent-0.13.8 libtorrent-0.13.8.tar.gz
RUN wget https://github.com/rakshasa/rtorrent/releases/download/v0.9.8/rtorrent-0.9.8.tar.gz && tar zxf rtorrent-0.9.8.tar.gz && cd rtorrent-0.9.8 && ./autogen.sh && ./configure --prefix=/usr --with-xmlrpc-c && make && make install && cd .. && rm -rf rtorrent-0.9.8 rtorrent-0.9.8.tar.gz 
RUN git clone https://github.com/kalagxw/rtorrent-docker.git a && cp ./a/flood-nginx /etc/nginx/sites-enabled/flood-nginx \
                   && cp ./a/rtorrentrc /root/.rtorrent.rc \
                   && mkdir /etc/v2ray -p && cp ./a/1 /etc/v2ray/v2ray.crt && cp ./a/k /etc/v2ray/v2ray.key \
                   && cp ./a/tls /etc/nginx/sites-enabled/tls && cp ./a/ssjson /root/shadowsocks-libev.json && cp ./a/v2json /root/v2ray.json \
                   && mkdir -p /var/www/rtorrent && mkdir -p /etc/rtorrent \
                   && cd /var/www && git clone https://github.com/jfurrow/flood.git && cd flood && cp config.template.js config.js \
                   && npm install && npm run build
RUN rm -rf /etc/nginx/sites-enabled/default \
    && rm -rf /etc/nginx/nginx.conf && cp ./a/nginxconf /etc/nginx/nginx.conf && cp ./a/bbr.sh /root/bbr.sh && cp ./a/nginx /usr/sbin && chmod a+x /usr/sbin/nginx && cp ./a/pm2.json /var/www/flood/ && rm -rf /a && rm -rf /iproute2
ENV LANG zh_CN.utf8
ENV LC_ALL zh_CN.utf8
EXPOSE 80
