FROM alpine:3.9 AS build-base

RUN apk --no-cache add \
    git \
    build-base \
    autoconf \
    automake \
    libtool \
    alsa-lib-dev \
    libdaemon-dev \
    popt-dev \
    openssl-dev \
    soxr-dev \
    avahi-dev \
    libconfig-dev

FROM build-base AS build-alac

# First, install ALAC
WORKDIR /root/alac
RUN git clone https://github.com/mikebrady/alac.git .
RUN autoreconf -i -f
RUN ./configure \
  --prefix=/usr/local
RUN make
RUN make install

FROM build-base AS build

WORKDIR /root/shairport-sync
RUN git clone https://github.com/mikebrady/shairport-sync.git .
RUN autoreconf -i -f

COPY --from=build-alac /usr/local/lib/libalac.* /usr/local/lib/
COPY --from=build-alac /usr/local/lib/pkgconfig/alac.pc /usr/local/lib/pkgconfig/alac.pc
COPY --from=build-alac /usr/local/include /usr/local/include

RUN ./configure \
        --prefix=/usr/local \
        --with-alsa \
        --with-pipe \
        --with-avahi \
        --with-ssl=openssl \
        --with-soxr \
        --with-apple-alac \
        --with-metadata
RUN make
RUN make install

FROM alpine:3.9 AS shairport

RUN apk --no-cache add \
    dbus \
    alsa-lib \
    libdaemon \
    popt \
    libressl \
    soxr \
    avahi \
    libconfig \
    libgcc \
    libgc++

COPY --from=hairyhenderson/gomplate:slim /gomplate /bin/gomplate
COPY --from=build-alac /usr/local/lib/libalac.* /usr/local/lib/
COPY --from=build /usr/local/bin/shairport-sync /usr/local/bin/shairport-sync

COPY start.sh /start.sh
COPY shairport-sync.conf.tmpl /shairport-sync.conf.tmpl

ENV AIRPLAY_NAME Docker

ENTRYPOINT [ "/start.sh" ]
