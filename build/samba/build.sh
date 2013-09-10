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

PROG=samba      # App name
VER=3.6.18      # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=service/network/samba # Package name (e.g. library/foo)
SUMMARY="$PROG - CIFS server and domain controller"      # One-liner, must be filled in
DESC="$SUMMARY ($VER)"         # Longer description, must be filled in
DOWNLOADURL="http://ftp.samba.org/pub/samba/samba-$VER.tar.gz"
BUILDARCH=32
BUILDDIR=$PROG-$VER/source3

BUILD_DEPENDS_IPS=library/openldap
RUN_DEPENDS_IPS=library/openldap

CONFIGURE_OPTS="
	--with-included-popt
	--with-pam
	--with-quotas
        --with-syslog
        --with-acl-support
        --with-aio-support
        --with-automount
        --disable-swat            
        --with-shared-modules=nfs4_acls,vfs_zfsacl"

CONFIGURE_OPTS_32="
  --with-fhs
  --prefix=$PREFIX
  --mandir=$PREFIX/share/man
  --sysconfdir=/etc
  --localstatedir=/var/samba
  --sharedstatedir=/var/samba" 

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/samba
    logcmd cp $SRCDIR/files/manifest-samba-nmbd.xml \
        $DESTDIR/lib/svc/manifest/network/samba/nmbd.xml
    logcmd cp $SRCDIR/files/manifest-samba-smbd.xml \
        $DESTDIR/lib/svc/manifest/network/samba/smbd.xml
    logcmd cp $SRCDIR/files/manifest-samba-winbindd.xml \
        $DESTDIR/lib/svc/manifest/network/samba/winbindd.xml
    logcmd cp $SRCDIR/files/smb.conf $DESTDIR/etc/samba/smb.conf
}
init
download_source $PROG $PROG $VER
patch_source
prep_build
build
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
