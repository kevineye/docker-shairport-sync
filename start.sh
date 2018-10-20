#!/bin/sh

rm -rf /var/run
mkdir -p /var/run/dbus

dbus-uuidgen --ensure
dbus-daemon --system

avahi-daemon --daemonize --no-chroot

echo "gomplating..."
mkdir -p /usr/local/etc
gomplate -f /shairport-sync.conf.tmpl -o /usr/local/etc/shairport-sync.conf
echo "done!"

shairport-sync "$@"
