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

PROG=libvorbis
VER=1.3.4
VERHUMAN=$VER
PKG=oep/audio/libvorbis
SUMMARY="$PROG - Vorbis Audio Compression (v$VER)"
DESC="$SUMMARY"
MIRROR=downloads.xiph.org
DLDIR=releases/vorbis
BUILDARCH=both

BUILD_DEPENDS_IPS="oep/audio/libogg"
RUN_DEPENDS_IPS="oep/audio/libogg"

LDFLAGS32="-L/opt/oep/lib -R/opt/oep/lib"
LDFLAGS64="-L/opt/oep/lib/$ISAPART64 -R/opt/oep/lib/$ISAPART64"

CONFIGURE_OPTS="--enable-shared"

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
