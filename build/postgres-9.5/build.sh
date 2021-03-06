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
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2016 OETIKER+PARTNER AG.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=postgresql
VER=9.5.9
VERHUMAN=$VER
PKG=oep/database/postgresql-9.5
SUMMARY="$PROG - Open Source Database System"
DESC="$SUMMARY"
MIRROR=ftp.postgresql.org/pub/source
DLDIR="v$VER"

PREFIX=/opt/oep/pgsql
reset_configure_opts

CFLAGS="-O3"
BUILDARCH=64

CONFIGURE_OPTS="--enable-thread-safety
    --with-openssl
    --with-libxml
    --prefix=$PREFIX
    --with-readline"

make_prog() {
    logmsg "--- make"
    logcmd $MAKE $MAKE_JOBS world || \
        logerr "--- Make failed"
}

make_install() {
    logmsg "--- make install"
    logcmd $MAKE DESTDIR=${DESTDIR} install-world || \
        logerr "--- Make install failed"
}

install_manifest() {
    tgtdir=${DESTDIR}/lib/svc/manifest/oep/postgres
    mkdir -p ${tgtdir}
    install -m 0444 ${SRCDIR}/postgresql.xml ${tgtdir}/ || logerr 'manifest install failed'
}

init
download_source $DLDIR $PROG $VER
patch_source
prep_build
build
install_manifest
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
