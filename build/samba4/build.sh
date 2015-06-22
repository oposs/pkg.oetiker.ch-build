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
VER=4.2.2      # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=oep/service/network/samba4 # Package name (e.g. library/foo)
SUMMARY="$PROG - CIFS server and domain controller"      # One-liner, must be filled in
DESC="$SUMMARY ($VER)"         # Longer description, must be filled in
DOWNLOADURL="http://ftp.samba.org/pub/samba/samba-$VER.tar.gz"
#BUILDARCH=both (64 keeps crashing)
BUILDARCH=32
BUILDDIR=$PROG-$VER
BUILD_DEPENDS_IPS="oep/library/openldap oep/library/security/libgpg-error oep/library/security/libgcrypt"
RUN_DEPENDS_IPS="oep/library/security/libgpg-error oep/library/security/libgcrypt"

CONFIGURE_OPTS="
  	--prefix=$PREFIX
  	--bindir=$PREFIX/bin
  	--sbindir=$PREFIX/sbin
	--mandir=$PREFIX/share/man
  	--libdir=$PREFIX/lib
  	--libexecdir=$PREFIX/libexec
	--infodir=$PREFIX/info
  	--sysconfdir=/etc/opt/oep/samba
	--with-configdir=/etc/opt/oep/samba
	--with-privatedir=/etc/opt/oep/samba/private
  	--localstatedir=/var/opt/oep/samba
  	--sharedstatedir=/var/opt/oep/samba
        --with-logfilebase=/var/opt/oep/log/samba
	--bundled-libraries=ALL
        --with-shared-modules=nfs4_acls,vfs_zfsacl,vfs_fruit
  	--with-pammodulesdir=/usr/lib/security
        --with-piddir=/var/run
        --with-winbind
        --with-ads
	--with-ldap
	--with-pam
	--with-iconv
        --with-acl-support
        --with-syslog
        --with-aio-support
	--enable-fhs
	--with-quotas
	--without-ad-dc
        --with-automount"

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/samba
    logcmd cp $SRCDIR/files/manifest-samba-nmbd.xml \
        $DESTDIR/lib/svc/manifest/network/samba/nmbd.xml
    logcmd cp $SRCDIR/files/manifest-samba-smbd.xml \
        $DESTDIR/lib/svc/manifest/network/samba/smbd.xml
    logcmd cp $SRCDIR/files/manifest-samba-winbindd.xml \
        $DESTDIR/lib/svc/manifest/network/samba/winbindd.xml
    logcmd cp $SRCDIR/files/smb.conf $DESTDIR/etc/opt/oep/samba/smb.conf
    logcmd mkdir $DESTDIR/var/opt/oep/log/samba
}

# overriding the normal install functions to get to copy the libnss stuff since
# samba does not seem to install it
make_install32() {
    make_install
    rm -rf $TMPDIR/$PROG-$VER/*/*.o
}
    

rm -rf $TMPDIR/$PROG-$VER || true

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
