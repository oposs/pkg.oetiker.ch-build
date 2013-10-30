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

PROG=collectd-web # App name
VER=20130327    # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=system/collectd/web # Package name (e.g. library/foo)
SUMMARY="Buffering/reblocking program for tape backups, printing, etc."      # One-liner, must be filled in
DESC="Buffer implements double buffering and can be used to keep backup tapes streaming or printers printing. It can also be used to convert a data stream to a given output blocksize."         # Longer description, must be filled in
DOWNLOADURL="http://ftp.de.debian.org/debian/pool/main/b/buffer/buffer_1.19.orig.tar.gz"
BUILDARCH=32    # or 64 or both ... for libraries we want both for tools 32 bit only
BUILDDIR=$PROG
BUILD_DEPENDS_IPS=
RUN_DEPENDS_IPS="database/rrdtool omniti/server/apache22 oep/server/apache22/mod_fcgid"

init
pushd $TMPDIR
[ -d $PROG ] && rm -rf $PROG
git clone https://github.com/httpdss/$PROG.git
popd
patch_source
prep_build
pwd
pushd $TMPDIR/collectd-web
CWROOT=$DESTDIR/opt/oep/share/collectd-web
bash setup.sh $CWROOT/thirdparty
mkdir -p $CWROOT/docroot
cp -r iphone media index.html $CWROOT/docroot
mkdir -p $CWROOT/docroot/cgi-bin
cp -r cgi-bin/*.cgi $CWROOT/docroot/cgi-bin
chmod 755 $CWROOT/docroot/cgi-bin/*.cgi
mkdir -p $DESTDIR/lib/svc/manifest/network/http/
cp $SRCDIR/files/collectd-web.xml $DESTDIR/lib/svc/manifest/network/http/collectd-web.xml
mkdir -p $DESTDIR/etc/opt/oep
cp $SRCDIR/files/collectd-web-httpd.conf $DESTDIR/etc/opt/oep
cp $SRCDIR/files/collectd-web.conf $DESTDIR/etc/opt/oep
mkdir -p $DESTDIR/etc/logadm.d
cp $SRCDIR/files/collectd-web-rotate.conf $DESTDIR/etc/logadm.d
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
