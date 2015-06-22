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

PROG=subversion
VER=1.8.13
VERHUMAN=$VER
PKG=oep/subversion
SUMMARY="$PROG - Revision control system (v$VER)"
DESC="$SUMMARY"
DOWNLOADURL="http://mirror.nexcess.net/apache/$PROG/$PROG-$VER.tar.gz"
BUILDARCH=32

BUILD_DEPENDS_IPS=
RUN_DEPENDS_IPS=

#CFLAGS="-lxnet -lsocket -lnsl -lkstat -D_XOPEN_SOURCE=500 -D__EXTENSIONS__ $CFLAGS"

CONFIGURE_OPTS=" \
	 --without-berkeley-db \
	 --without-apache \
	 --without-apxs \
 	 --without-swig \
"

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
