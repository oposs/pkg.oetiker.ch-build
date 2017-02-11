#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 1995-2017 OETIKER+PARTNER AG  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=openvpn
VER=2.3.14
LZOLIB_VER=2.09
VERHUMAN=$VER
PKG=oep/network/openvpn
SUMMARY="OpenVPN -- A Secure tunneling daemon"
DESC="$SUMMARY"
MIRROR=swupdate.openvpn.org
DLDIR=community/releases

BUILDARCH=64
CONF_DEFAULT="$CONFIGURE_OPTS"
CONFIGURE_OPTS="$CONFIGURE_OPTS --disable-server"

BUILD_DEPENDS_IPS="library/security/openssl driver/tuntap"
RUN_DEPENDS_IPS="library/security/openssl driver/tuntap"

download_tgz() {
    [ -f "$1" ] || logcmd /usr/bin/wget -O "$1" "$2"
    [ -d "$3" ] && /usr/bin/rm -rf "$3"
    logcmd /usr/bin/tar xfz "$1"
}

build_lzo() {
    local PROG="lzo"
    local FOLDER="${PROG}-${LZOLIB_VER}"
    local FILE="${FOLDER}.tar.gz"
    local URL="http://www.oberhumer.com/opensource/${PROG}/download/${FILE}"
    local CONFIGURE_OPTS="$CONF_DEFAULT"
    echo "Building ${PROG}"
    download_tgz "$FILE" "$URL" "$FOLDER"
    cd $FOLDER
    configure64
    make_prog64
    cd ..
    CPPFLAGS="$CPPFLAGS -I$TMPDIR/$FOLDER/include"
    LDFLAGS="$LDFLAGS -L$TMPDIR/$FOLDER/src/.libs"
}

config_dir() {
    logmsg "--- Creating config directory"
    logcmd mkdir -p $DESTDIR/etc/opt/oep/$PROG ||
        logerr "Failed to crate config directory"
}

service_configs() {
    logmsg "--- Copying SMF manifest"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/manifest-openvpn.xml \
    $DESTDIR/lib/svc/manifest/network/openvpn.xml ||
        logerr "Failed to copy SMF manifest"

    logmsg "--- Copying SMF start script"
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/net-openvpn \
    $DESTDIR/lib/svc/method/net-openvpn ||
        logerr "Failed to copy SMF start script"
}

init
download_source $DLDIR $PROG $VER
patch_source
pushd $TMPDIR >/dev/null
build_lzo
popd >/dev/null
prep_build
build
make_isa_stub
config_dir
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
