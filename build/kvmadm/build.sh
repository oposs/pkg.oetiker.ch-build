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

PROG=kvmadm # App name
VER=0.8.2    # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=oep/kvmadm # Package name (e.g. library/foo)
SUMMARY="a smf based kvm manager"      # One-liner, must be filled in
DESC="Run your kvm hosts via smf"         # Longer description, must be filled in
BUILDARCH=32    # or 64 or both ... for libraries we want both for tools 32 bit only
BUILDDIR=$PROG
BUILD_DEPENDS_IPS=
RUN_DEPENDS_IPS=

init
pushd $TMPDIR
[ -d $PROG ] && rm -rf $PROG
mkdir $PROG
cd $PROG
curl -L https://github.com/hadfl/kvmadm/releases/download/v$VER/kvmadm-$VER.tar.gz | gtar zxf -
cd kvmadm-$VER
prep_build
./configure --prefix=/opt/oep --disable-svcimport
gmake install DESTDIR=$DESTDIR

logmsg "Installing SMF"
logcmd mkdir -p $DESTDIR/lib/svc/manifest/oep/kvmadm
logcmd cp $DESTDIR/opt/oep/share/kvmadm/smf/system-kvm.xml $DESTDIR/lib/svc/manifest/oep/kvmadm

make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
