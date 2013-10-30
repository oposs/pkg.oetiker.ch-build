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

PROG=mod_fcgid      # App name
VER=2.3.7         # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=oep/server/apache22/mod_fcgid            # Package name (e.g. library/foo)
SUMMARY="apache22 module to support fcgi"      # One-liner, must be filled in
DESC="fcgi module for omniti/server/apache22"         # Longer description, must be filled in
DOWNLOADURL="http://www.trieuvan.com/apache//httpd/mod_fcgid/mod_fcgid-2.3.7.tar.bz2"
BUILDARCH=64    # or 64 or both ... for libraries we want both for tools 32 bit only

BUILD_DEPENDS_IPS=omniti/server/apache22
RUN_DEPENDS_IPS=omniti/server/apache22

init
download_source $PROG $PROG $VER
patch_source
prep_build
export PATH=/opt/gcc-4.6.3/bin:/opt/apache22/bin:$PATH
pushd $TMPDIR/mod_fcgid-2.3.7
./configure.apxs
make
make install DESTDIR=$DESTDIR
rm -rf $DESTDIR/opt/apache22/conf
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
