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

PROG=apr     # App name
VER=1.5.2      # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=oep/apr     # Package name (e.g. library/foo)
SUMMARY="$PROG - Apache Portable Runtime"   # One-liner, must be filled in
DESC="$SUMMARY ($VER)"         # Longer description, must be filled in
DOWNLOADURL="http://mirrors.gigenet.com/apache//apr/apr-$VER.tar.gz"
BUILDARCH=32
BUILDDIR=$PROG-$VER

CONFIGURE_OPTS="
  	--prefix=$PREFIX
  	--bindir=$PREFIX/bin
  	--sbindir=$PREFIX/sbin
	--mandir=$PREFIX/share/man
  	--libdir=$PREFIX/lib
  	--libexecdir=$PREFIX/libexec
	--infodir=$PREFIX/info
  	--sysconfdir=/etc/opt/oep/apr
	--with-configdir=/etc/opt/oep/apr
	--with-privatedir=/etc/opt/oep/apr/private
  	--localstatedir=/var/opt/oep/apr
  	--sharedstatedir=/var/opt/oep/apr
        --with-logfilebase=/var/opt/oep/log/apr
        --with-piddir=/var/run"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up


# vim:ts=4:sw=4:et:
