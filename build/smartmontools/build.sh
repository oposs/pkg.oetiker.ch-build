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
# Copyright 1995-2013 OETIKER+PARTNER AG  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=smartmontools
VER=6.4
VERHUMAN=$VER
PKG=oep/system/storage/smartmontools
SUMMARY="Control and monitor storage systems using SMART"
DESC="$SUMMARY"
MIRROR=sourceforge.net
DLDIR=projects/$PROG/files/$PROG/$VER

BUILDARCH=64

CPPFLAGS64="$CPPFLAGS64 -D_AVL_H"

CONFIGURE_OPTS_64="--prefix=$PREFIX
    --sysconfdir=/etc$PREFIX/smartmontools
    --includedir=$PREFIX/include
    --bindir=$PREFIX/bin/$ISAPART64
    --sbindir=$PREFIX/sbin/$ISAPART64
    --libdir=$PREFIX/lib/$ISAPART64
    --libexecdir=$PREFIX/libexec/$ISAPART64"

service_configs() {
    logmsg "--- Copying SMF manifest"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/system/storage
    logcmd cp $SRCDIR/files/manifest-smartd.xml \
    $DESTDIR/lib/svc/manifest/system/storage/smartd.xml ||
    logerr "Failed to copy SMF manifest"
}

init
download_source $DLDIR $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
chown root:sys $DESTDIR/etc/opt
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
