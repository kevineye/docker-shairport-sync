FROM fedora

RUN dnf install -y -q \
    alsa-lib-devel \
    autoconf \
    automake \
    avahi-devel \
    gcc \
    gcc-c++ \
    kernel-devel \
    libconfig-devel \
    libdaemon-devel \
    make \
    openssl \
    openssl-devel \
    popt-devel \
    rpm-build \
    soxr-devel

RUN curl -s -L -o /root/shairport-sync-2.6.tar.gz https://github.com/mikebrady/shairport-sync/archive/2.6.tar.gz \
 && rpmbuild -ta /root/shairport-sync-2.6.tar.gz \
 && rpm -i /root/rpmbuild/RPMS/x86_64/shairport-sync-2.6-1.fc23.x86_64.rpm

RUN mkdir /var/run/dbus

ENV AIRPLAY_NAME Docker

CMD dbus-daemon --system && avahi-daemon -D  && shairport-sync -a $AIRPLAY_NAME
