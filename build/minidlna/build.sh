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
# Copyright 1995-2014 OETIKER+PARTNER AG  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=minidlna
VER=1.1.4
VERHUMAN=$VER
PKG=oep/multimedia/minidlna
SUMMARY="$PROG - a fully compliant DLNA/UPnP server (v$VER)"
DESC="$SUMMARY"
MIRROR=sourceforge.net
DLDIR=projects/$PROG/files/$PROG/$VER
BUILDARCH=32

BUILD_DEPENDS_IPS="database/sqlite-3 oep/multimedia/ffmpeg oep/graphics/libexif oep/audio/libid3tag oep/audio/libvorbis oep/audio/flac oep/graphics/libjpeg"
RUN_DEPENDS_IPS="database/sqlite-3 oep/multimedia/ffmpeg oep/graphics/libexif oep/audio/libid3tag oep/audio/libvorbis oep/audio/flac oep/graphics/libjpeg"

CONFIGURE_OPTS="--sysconfdir=/etc/opt/oep"

CPPFLAGS32="-I/opt/oep/include -I/usr/include"
LDFLAGS32="-L/opt/oep/lib -L/usr/lib -R/opt/oep/lib -lsocket -lnsl -lsendfile"

service_configs() {
    logmsg "--- Copying SMF manifest"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/multimedia
    logcmd cp $SRCDIR/files/manifest-minidlna.xml \
    $DESTDIR/lib/svc/manifest/multimedia/minidlna.xml ||
        logerr "Failed to copy SMF manifest"
}

init
download_source $DLDIR $PROG $VER
patch_source
prep_build
build
make_isa_stub
#service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
