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
# Copyright 1995-2014 OETIKER+PARTNER AG.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=ffmpeg
VER=3.0
VERHUMAN=$VER
PKG=oep/multimedia/ffmpeg
SUMMARY="$PROG - The Leading Multimedia Framework (v$VER)"
DESC="$SUMMARY"
MIRROR=ffmpeg.org
DLDIR=releases
BUILDARCH=both

BUILD_DEPENDS_IPS="oep/developer/yasm"
RUN_DEPENDS_IPS=

CPPFLAGS32="$CPPFLAGS32 -I$PREFIX/include"
LDFLAGS32="$LDFLAGS32 -L$PREFIX/lib/$ISAPART32 -R$PREFIX/lib/$ISAPART32"

CPPFLAGS64="$CPPFLAGS64 -I$PREFIX/include/$ISAPART64"
LDFLAGS64="$LDFLAGS64 -L$PREFIX/lib/$ISAPART64 -R$PREFIX/lib/$ISAPART64"

CONFIGURE_OPTS="
    --prefix=$PREFIX
    --enable-shared" 

CONFIGURE_OPTS_32="
    --bindir=$PREFIX/bin/$ISAPART
    --libdir=$PREFIX/lib
    --shlibdir=$PREFIX/lib"

CONFIGURE_OPTS_64="
    --bindir=$PREFIX/bin/$ISAPART64
    --libdir=$PREFIX/lib/$ISAPART64
    --shlibdir=$PREFIX/lib/$ISAPART64"

init
download_source $DLDIR $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
