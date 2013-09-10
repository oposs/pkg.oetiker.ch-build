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

PROG=pkg-config # App name
VER=0.28       # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=developer/build/pkg-config # Package name (e.g. library/foo)
SUMMARY="helper tool used when compiling applications and libraries"      # One-liner, must be filled in
DESC="pkg-config helps you insert the correct compiler options on the command line so an application can use gcc -o test test.cpkg-config --libs --cflags glib-2.0 for instance, rather than hard-coding values on where to find glib (or other libraries). It is language-agnostic, so it can be used for defining the location of documentation tools, for instance."         # Longer description, must be filled in
DOWNLOADURL=http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz
BUILDARCH=32

BUILD_DEPENDS_IPS="library/glib2 developer/build/libtool"
RUN_DEPENDS_IPS=library/glib2


CONFIGURE_OPTS='GLIB_LIBS=-lglib-2.0'

# alternate
CONFIGURE_CMD=my_configure
my_configure() {
    logmsg "--- creating makefiles"
    ./configure $CONFIGURE_OPTS_32 $CONFIGURE_OPTS GLIB_CFLAGS="-I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include/"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
