#!/usr/bin/bash
#
# Load support functions
. ../../lib/functions.sh

PROG=bind9
VER=9.10.4.4
VERHUMAN=9.10.4-P4
PKG=oep/service/network/bind9
SUMMARY="BIND DNS server and tools"
DESC="$SUMMARY ($VER)"
BUILDDIR=bind-$VERHUMAN
MIRROR=ftp.isc.org/isc/bind
DLDIR=$VERHUMAN

PREFIX=/opt/oep/${PROG}

RUN_DEPENDS_IPS="library/libxml2 library/security/openssl library/zlib
                 system/library system/library/gcc-4-runtime system/library/math"

CONFIGURE_OPTS="
    --bindir=$PREFIX/sbin
    --sbindir=$PREFIX/sbin
    --libdir=$PREFIX/lib/dns
    --sysconfdir=/etc/opt/oep/${PROG}
    --localstatedir=/var/opt/oep/${PROG}
    --with-libtool
    --disable-static
"

basic_named_config() {
    logmsg "Installing basic named.conf"
    logcmd mkdir -p $DESTDIR/etc/opt/oep/${PROG}
    logcmd cp $SRCDIR/files/named.conf \
        $DESTDIR/etc/opt/oep/${PROG}/named.conf.sample
    logcmd mkdir -p $DESTDIR/var/opt/oep/${PROG}/named/master
    logcmd mkdir -p $DESTDIR/var/opt/oep/${PROG}/named/rev
    logcmd cp $SRCDIR/files/root.servers \
        $DESTDIR/var/opt/oep/${PROG}/named/root.servers
    logcmd cp $SRCDIR/files/zone.localhost \
        $DESTDIR/var/opt/oep/${PROG}/named/master/zone.localhost
    logcmd cp $SRCDIR/files/127.0.0.rev \
        $DESTDIR/var/opt/oep/${PROG}/named/rev/127.0.0.rev
}

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/oep/network
    logcmd cp $SRCDIR/files/bind9.xml $DESTDIR/lib/svc/manifest/oep/network/bind9.xml
    logmsg "Installing SMF control methods"
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/bind9  $DESTDIR/lib/svc/method/bind9
    logcmd chmod 555 $DESTDIR/lib/svc/method/bind9
}

init
download_source $DLDIR bind $VERHUMAN
patch_source
prep_build
build
make_isa_stub
basic_named_config
service_configs
make_package
clean_up
