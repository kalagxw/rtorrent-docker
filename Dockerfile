FROM kalagxw/ubuntu-sshd
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y git-core dnsutils iputils-ping net-tools
RUN apt-get install -y software-properties-common && add-apt-repository ppa:ondrej/nginx-mainline && add-apt-repository ppa:ondrej/nginx-qa \
&& add-apt-repository ppa:libtorrent.org/rc-1.1-daily && apt-get update && apt-get upgrade -y openssl \
&& curl -sL https://deb.nodesource.com/setup_10.x | bash - \
&& apt update && apt install nodejs -y && npm -g install npm@next
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y wget libtorrent-dev rtorrent nginx-extras unzip tzdata mediainfo \
                   && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata                 
RUN git clone https://github.com/kalagxw/rtorrent-docker.git a && cp ./a/flood-nginx /etc/nginx/sites-enabled/flood-nginx \
                   && cd /var/www && git clone https://github.com/jfurrow/flood.git && cd flood && cp config.template.js config.js \
                   && npm install && npm run build \
&& cd /root/ && cp ./a/rtorrentrc /root/.rtorrent.rc \
&& mkdir /etc/v2ray -p && cp ./a/1 /etc/v2ray/v2ray.crt && cp ./a/k /etc/v2ray/v2ray.key \
&& cp ./a/tls /etc/nginx/sites-enabled/tls && cp ./a/ssjson /root/shadowsocks-libev.json && cp ./a/v2json /root/v2ray.json \
&& mkdir -p /var/www/rtorrent && mkdir -p /etc/rtorrent
RUN rm -rf /etc/nginx/sites-enabled/default \
    && rm -rf /etc/nginx/nginx.conf && cp ./a/nginxconf /etc/nginx/nginx.conf && cp ./a/bbr.sh /root/bbr.sh
    
EXPOSE 80
