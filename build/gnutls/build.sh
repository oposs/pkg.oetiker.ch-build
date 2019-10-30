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

PROG=gnutls    # App name
VER=3.6.10     # App version
VERHUMAN=$VER  # Human-readable version
#PVER=         # Branch (set in config.sh, override here if needed)
PKG=oep/library/security/gnutls # Package name (e.g. library/foo)
SUMMARY="$PROG - CIFS server and domain controller"      # One-liner, must be filled in
DESC="$SUMMARY ($VER)"         # Longer description, must be filled in
DOWNLOADURL="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-$VER.tar.xz"
BUILDARCH=64
BUILDDIR=$PROG-$VER
BUILD_DEPENDS_IPS="oep/library/security/nettle oep/library/security/libtasn1"
RUN_DEPENDS_IPS="oep/library/security/nettle oep/library/security/libtasn1"

PREFIX=/opt/oep
CONFIGURE_OPTS_64="
        --prefix=$PREFIX
        --bindir=$PREFIX/bin/$ISAPART64
        --sbindir=$PREFIX/sbin/$ISAPART64
        --libdir=$PREFIX/lib/$ISAPART64
  	--disable-dependency-tracking --enable-hardware-acceleration --disable-static --enable-shared --without-tpm --with-included-unistring --without-p11-kit
"                                                    
CONFIGURE_OPTS="
"


 
rm -rf $TMPDIR/$PROG-$VER || true

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
cd /
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
