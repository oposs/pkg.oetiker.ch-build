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

PROG=libgcrypt
VER=1.8.3
VERHUMAN=$VER
PKG=oep/library/security/libgcrypt
SUMMARY="Libgcrypt is GNU's basic cryptographic library."
DESC="Libgcrypt is a general purpose cryptographic library based on the code from GnuPG. It provides functions for all cryptographic building blocks: symmetric ciphers, hash algorithms, MACs, public key algorithms, large integer functions, random numbers and a lot of supporting functions."

DEPENDS_IPS="oep/library/security/libgpg-error"

BUILDARCH=both
#BUILDARCH=32

CPPFLAGS64="$CPPFLAGS64 -D_AVL_H"
CPPFLAGS32="$CPPFLAGS32 -D_AVL_H"

CONFIGURE_OPTS_32="--prefix=$PREFIX
  --includedir=$PREFIX/include
  --bindir=$PREFIX/bin/$ISAPART
  --sbindir=$PREFIX/sbin/$ISAPART
  --libdir=$PREFIX/lib
  --libexecdir=$PREFIX/libexec"

CONFIGURE_OPTS_64="--prefix=$PREFIX
  --includedir=$PREFIX/include
  --bindir=$PREFIX/bin/$ISAPART64
  --sbindir=$PREFIX/sbin/$ISAPART64
  --libdir=$PREFIX/lib/$ISAPART64
  --libexecdir=$PREFIX/libexec/$ISAPART64"


DOWNLOADURL=http://mirror.switch.ch/ftp/mirror/gnupg/libgcrypt/${PROG}-${VER}.tar.gz

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
