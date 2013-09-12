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

PROG=rrdtool    # App name
VER=1.4.8       # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=database/rrdtool            # Package name (e.g. library/foo)
SUMMARY="log time series data and create pretty graphs"      # One-liner, must be filled in
DESC="industry standard time series database with charting ability"         # Longer description, must be filled in
DOWNLOADURL="http://www.rrdtool.org/pub/rrdtool-1.4.8.tar.gz"
BUILDARCH=32  # or 64 or both ... for libraries we want both for tools 32 bit only

BUILD_DEPENDS_IPS=library/pango
RUN_DEPENDS_IPS=library/pango

CPPFLAGS32="-I/opt/oep/include -I/opt/omni/include"
LDFLAGS32="-L/opt/oep/lib -R/opt/oep/lib -L/opt/omni/lib -R/opt/omni/lib"
CONFIGURE_OPTS="--enable-perl-site-install --disable-mmap"

add_font() {
    logmsg "Installing DejaVueMono"
    logcmd mkdir -p $DESTDIR/usr/share/fonts/truetype/ttf-dejavue
    logcmd cp $SRCDIR/fonts/* $DESTDIR/usr/share/fonts/truetype/ttf-dejavue
}
                                                                                                
init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
add_font
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
