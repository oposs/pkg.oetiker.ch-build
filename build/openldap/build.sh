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
PKG=oep/library/openldap # Package name (e.g. library/foo)
SUMMARY="openldap ldap library"      # One-liner, must be filled in
DESC="an opensource implementation of ldap with library and tools"         # Longer description, must be filled in

BUILDARCH=both

CPPFLAGS64="$CPPFLAGS64 -D_AVL_H"
CPPFLAGS32="$CPPFLAGS32 -D_AVL_H"

CONFIGURE_OPTS="--with-tls --enable-modules --enable-crypt --without-cyrus-sasl
  --without-subdir --enable-syslog --enable-proctitle --enable-overlays
  --enable-accesslog --enable-lmpasswd --enable-ldap 
  --disable-static --enable-bdb=no --enable-hdb=no --enable-mdb"


CONFIGURE_OPTS_32="--prefix=$PREFIX
  --sysconfdir=/etc/opt/oep/ldap
  --includedir=$PREFIX/include
  --bindir=$PREFIX/bin/$ISAPART
  --sbindir=$PREFIX/sbin/$ISAPART
  --libdir=$PREFIX/lib
  --libexecdir=$PREFIX/libexec
  --localstatedir=/var/opt/oep"


CONFIGURE_OPTS_64="--prefix=$PREFIX
  --sysconfdir=/etc/opt/oep/ldap
  --includedir=$PREFIX/include
  --bindir=$PREFIX/bin/$ISAPART64
  --sbindir=$PREFIX/sbin/$ISAPART64
  --libdir=$PREFIX/lib/$ISAPART64
  --libexecdir=$PREFIX/libexec/$ISAPART64
  --localstatedir=/var/opt/oep"


save_function make_prog make_prog_orig
make_prog(){
    logmsg "--- make depend"
    logcmd $MAKE depend || \
        logerr "--- make depend failed"
    make_prog_orig
}

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/ldap
    logcmd cp $SRCDIR/files/manifest-openldap.xml \
        $DESTDIR/lib/svc/manifest/network/ldap/openldap.xml
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp -a $SRCDIR/files/slapd \
        $DESTDIR/lib/svc/method/slapd
}

init
download_source $PROG $PROG $VER
patch_source -p0
prep_build
build
make_isa_stub
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
