FROM debian:bullseye

RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommends

RUN apt-get update && apt-get install wget ca-certificates -y

RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN \
apt-get update && apt-get upgrade -y && \
DEBIAN_FRONTEND=noninteractive \
apt-get install -y git \
vim bash-completion \
nginx supervisor procps \
apt-transport-https \
mariadb-client python3-venv python3-pip

RUN mkdir /var/www/fileserver
#RUN mkdir /var/www/fileserver/status

COPY supervisord.conf /etc/supervisor/supervisord.conf
#COPY main.py /var/www/fileserver/main.py
COPY start_status.sh /start_status.sh

COPY supervisor.sh /supervisor.sh
CMD ["./supervisor.sh"]

EXPOSE 80 443
