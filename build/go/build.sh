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
# Copyright 2014 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2016 OETIKER+PARTNER AG.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=go
VER=1.9.2
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=oep/developer/go
SUMMARY="An open source programming language."
DESC=$SUMMARY
MIRROR="storage.googleapis.com"
DLDIR="golang"
BUILDDIR=$PROG

TAR=gtar
BUILD_DEPENDS_IPS=oep/developer/go

# Tricks so we can make the installation land in the right place.
export GOROOT_FINAL=$PREFIX/go
export GOROOT_BOOTSTRAP=$PREFIX/go
export GOPATH="$DESTDIR/$PREFIX/go"

export LD_LIBRARY_PATH=/opt/gcc-5/lib/amd64
export CONFIGURE_OPTS_64="$CONFIGURE_OPTS_64 LDFLAGS=-Wl,-L/opt/gcc-5/lib/amd64,-R/opt/gcc-5/lib/amd64"

make_clean() {
    cd $TMPDIR/$BUILDDIR/src
    logcmd  ./clean.bash
    cd ..
}
configure32() {
    echo "NOP" >/dev/null
}

make_prog32() {
    echo "NOP" >/dev/null
}

make_install32() {
    echo "NOP" >/dev/null
}

configure64() {
    logcmd mkdir -p $DESTDIR/$PREFIX || \
    logerr "Failed to create Go install directory."
}

make_prog64() {
    logmsg "Making libraries (64)"
    cd $TMPDIR/$BUILDDIR/src
    logcmd  ./all.bash || logerr "build failed"
    cd ..
}

make_install64() {
    logmsg "Installing libraries (64)"
    logcmd mv $TMPDIR/$BUILDDIR $DESTDIR$GOROOT_FINAL || logerr "Failed to install Go"
    # For packaging purposes...
    ln -s $DESTDIR/$PREFIX/go $TMPDIR/$BUILDDIR
}

init
download_source $DLDIR $PROG${VER}.src
patch_source
prep_build

build

make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
