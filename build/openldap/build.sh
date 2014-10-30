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

PROG=openldap   # App name
VER=2.4.40      # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=library/openldap # Package name (e.g. library/foo)
SUMMARY="openldap ldap library"      # One-liner, must be filled in
DESC="an opensource implementation of ldap with library and tools"         # Longer description, must be filled in
DOWNLOADURL="ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.40.tgz"
BUILDARCH=both

BUILD_DEPENDS_IPS="omniti/database/bdb developer/build/pkg-config"
RUN_DEPENDS_IPS=omniti/database/bdb

CPPFLAGS64="$CPPFLAGS64 -D_AVL_H"
CPPFLAGS32="$CPPFLAGS32 -D_AVL_H"

CONFIGURE_OPTS="--with-tls --enable-modules --enable-crypt --without-cyrus-sasl
  --without-subdir --enable-syslog --enable-proctitle --enable-overlays
  --enable-accesslog --enable-lmpasswd --enable-ldap
  --disable-static"

CONFIGURE_OPTS_32="--prefix=$PREFIX
  --sysconfdir=/etc/ldap
  --includedir=$PREFIX/include
  --bindir=$PREFIX/bin/$ISAPART
  --sbindir=$PREFIX/sbin/$ISAPART
  --libdir=$PREFIX/lib
  --libexecdir=$PREFIX/libexec"

CONFIGURE_OPTS_64="--prefix=$PREFIX
  --sysconfdir=/etc/ldap
  --includedir=$PREFIX/include
  --bindir=$PREFIX/bin/$ISAPART64
  --sbindir=$PREFIX/sbin/$ISAPART64
  --libdir=$PREFIX/lib/$ISAPART64
  --libexecdir=$PREFIX/libexec/$ISAPART64"

init
download_source $PROG $PROG $VER
patch_source -p0
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
