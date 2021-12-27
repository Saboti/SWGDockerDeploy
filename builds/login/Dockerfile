FROM debian:buster

RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommends

RUN \
apt-get update && apt-get upgrade -y && \
DEBIAN_FRONTEND=noninteractive \
apt-get install -y build-essential \
libmariadbclient-dev \
libmariadbclient-dev-compat \
liblua5.3-dev libdb5.3-dev \
libssl-dev cmake \
git default-jre \
curl wget gdb supervisor \
tmux python vim screen \
cron ssh bash-completion

COPY build.sh /build.sh
COPY login_init.sh /login_init.sh
COPY start_core3.sh /start_core3.sh

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisor.sh /supervisor.sh
CMD ["./supervisor.sh"]
