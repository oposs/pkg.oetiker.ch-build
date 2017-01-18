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
# Copyright 1995-2017 OETIKER+PARTNER AG  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=lxadm      # App name
VER=0.1.2       # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=oep/lxadm   # Package name (e.g. library/foo)
SUMMARY="Manage Illumos LX zones"      # One-liner, must be filled in
DESC="Manage Illumos LX zones"         # Longer description, must be filled in
BUILDARCH=32    # or 64 or both ... for libraries we want both for tools 32 bit only
BUILDDIR=$PROG
BUILD_DEPENDS_IPS=
RUN_DEPENDS_IPS=
PREFIX=/opt/oep/${PROG}

init
pushd $TMPDIR
[ -d $PROG ] && rm -rf $PROG
mkdir $PROG
cd $PROG
curl -L https://github.com/hadfl/${PROG}/releases/download/v$VER/${PROG}-$VER.tar.gz | gtar zxf -
cd ${PROG}-$VER
prep_build
./configure --prefix=$PREFIX
gmake
gmake install DESTDIR=$DESTDIR

# create symbolic link to standard bin dir
logcmd mkdir -p $DESTDIR/opt/oep/bin
logcmd ln -s ${PREFIX}/bin/$PROG $DESTDIR/opt/oep/bin/$PROG
# create symbolic link to man page
logcmd mkdir -p $DESTDIR/opt/oep/share/man/man1
logcmd ln -s ${PREFIX}/share/man/man1/${PROG}.1 $DESTDIR/opt/oep/share/man/man1/${PROG}.1

make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
