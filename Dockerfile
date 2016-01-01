FROM debian:jessie
MAINTAINER kevineye@gmail.com

ENV SHAIRPORT_VERSION=2.6

ENV RUNTIME_PACKAGES="libdaemon0 libasound2 libpopt0 libconfig9 avahi-daemon libavahi-client3 libpolarssl7 libsoxr0"
ENV BUILD_PACKAGES="git gcc make autoconf libtool-bin libdaemon-dev libasound2-dev libpopt-dev libconfig-dev avahi-daemon libavahi-client-dev libpolarssl-dev libsoxr-dev"

# install build dependencies
RUN apt-get update -q \
 && apt-get install -y -q $RUNTIME_PACKAGES $BUILD_PACKAGES \

# download shairport-sync
 && cd /root \
 && git clone https://github.com/mikebrady/shairport-sync.git \
 && cd /root/shairport-sync \
 && git checkout -q tags/$SHAIRPORT_VERSION \

# build shairport
 && autoreconf -i -f \
 && ./configure --with-alsa --with-pipe --with-avahi --with-ssl=polarssl --with-soxr --with-metadata \
 && make \
 && make install \
 && cd / \

# clean build dependencies
 && apt-get remove --purge -y -q $BUILD_PACKAGES `apt-mark showauto` \

# reinstall runtime dependencies
 && apt-get install -y -q $RUNTIME_PACKAGES \
 
# cleanup
 && rm -rf /root/shairport-sync /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY start.sh /start

ENV AIRPLAY_NAME Docker

ENTRYPOINT [ "/start" ]
