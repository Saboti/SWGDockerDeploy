FROM debian:bullseye

RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommends

RUN apt-get update && apt-get install wget ca-certificates -y

RUN \
apt-get update && apt-get upgrade -y && \
DEBIAN_FRONTEND=noninteractive \
apt-get install -y git \
vim bash-completion \
mariadb-server \
supervisor procps \
apt-transport-https

RUN mkdir /run/mysqld

COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN chown -R mysql: /var/run/mysqld

COPY supervisor.sh /supervisor.sh
CMD ["./supervisor.sh"]
