FROM debian:buster

ENTRYPOINT ["tail", "-f", "/dev/null"]

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
curl wget gdb \
tmux python vim \
cron ssh bash-completion && \

RUN \
mkdir -p /home/swg/workspace/tre && \
#cd /home/swg/workspace/Core3/MMOCoreORB/ && make -j$(nproc)
