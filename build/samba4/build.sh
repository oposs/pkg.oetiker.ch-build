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

PROG=samba     # App name
VER=4.6.4      # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=oep/service/network/samba4 # Package name (e.g. library/foo)
SUMMARY="$PROG - CIFS server and domain controller"      # One-liner, must be filled in
DESC="$SUMMARY ($VER)"         # Longer description, must be filled in
DOWNLOADURL="http://ftp.samba.org/pub/samba/samba-$VER.tar.gz"
#BUILDARCH=both (64 keeps crashing)
BUILDARCH=64
BUILDDIR=$PROG-$VER
BUILD_DEPENDS_IPS="oep/library/openldap oep/library/security/libgpg-error oep/library/security/libgcrypt"
RUN_DEPENDS_IPS="oep/library/security/libgpg-error oep/library/security/libgcrypt"

PREFIX=/opt/oep/samba
CONFIGURE_OPTS_64="
        --prefix=$PREFIX
        --bindir=$PREFIX/bin/$ISAPART64
        --sbindir=$PREFIX/sbin/$ISAPART64
        --libdir=$PREFIX/lib/$ISAPART64
  	--with-pammodulesdir=/usr/lib/security/$ISAPART64
"                                                    
CONFIGURE_OPTS="
  	--sysconfdir=/etc/opt/oep/$PROG
	--with-configdir=/etc/opt/oep/$PROG
	--with-privatedir=/etc/opt/oep/$PROG/private
  	--localstatedir=/var/opt/oep/$PROG
  	--sharedstatedir=/var/opt/oep/$PROG
        --with-logfilebase=/var/opt/oep/log/$PROG
        --with-piddir=/var/run
	--without-ad-dc
	--with-ldap
	--with-iconv
        --with-acl-support        
        --with-winbind
	--with-pam
        --with-syslog
	--with-quotas
        --with-automount
	--with-shared-modules=vfs_zfsacl
"

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/oep/network
    logcmd cp $SRCDIR/files/manifest-samba-nmbd.xml \
        $DESTDIR/lib/svc/manifest/oep/network/samba-nmbd.xml
    logcmd cp $SRCDIR/files/manifest-samba-smbd.xml \
        $DESTDIR/lib/svc/manifest/oep/network/samba-smbd.xml
    logcmd cp $SRCDIR/files/manifest-samba-winbindd.xml \
        $DESTDIR/lib/svc/manifest/oep/network/samba-winbindd.xml
    logcmd cp $SRCDIR/files/smb.conf $DESTDIR/etc/opt/oep/samba/smb.conf
    logcmd mkdir $DESTDIR/var/opt/oep/log/samba
}

applinks_configs() {
    logmsg "Adding Links"
    logcmd mkdir -p $DESTDIR/opt/oep/bin
    logcmd cd $DESTDIR/opt/oep/bin
    logcmd ln -s ../$PROG/bin/* .
    logcmd rm amd64
    logcmd mkdir -p $DESTDIR/usr/lib/$ISAPART64
    logcmd cd $DESTDIR/usr/lib/$ISAPART64
    logcmd ln -s ../../../opt/oep/samba/lib/$ISAPART64/nss_winbind.so.1 nss_winbind.so
}

 
rm -rf $TMPDIR/$PROG-$VER || true

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
applinks_configs
make_package
cd /
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
