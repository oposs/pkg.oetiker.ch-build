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
# Copyright 1995-2018 OETIKER+PARTNER AG  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=mattermost
VER=4.9.2
VERHUMAN=$VER
PKG=oep/social/mattermost
SUMMARY="$PROG - All your team communication in one place, instantly searchable and accessible anywhere."
DESC="$SUMMARY"
MIRROR=github.com/$PROG
BUILDDIR=$PROG/src/$MIRROR/$PROG-server
BUILDARCH=64

export GOPATH=$TMPDIR/$PROG
export BUILD_NUMBER=$VER

BUILD_DEPENDS_IPS="developer/versioning/git
    oep/developer/go"

RUN_DEPENDS_IPS=

download_git() {
    logmsg "Making build directory"
    logcmd mkdir -p $TMPDIR/$PROG/src/$MIRROR || logerr "Cannot make build directory"
    cd $TMPDIR/$PROG/src/$MIRROR
    [ -d $TMPDIR/$BUILDDIR ] && rm -rf $TMPDIR/$BUILDDIR
    logmsg "Cloning git repository (tag v$VER)"
    logcmd git clone --branch v$VER --depth 1 https://$MIRROR/$PROG-server.git || logerr "Cannot clone repository"
}

configure64() {
    echo "NOP" >/dev/null
}

make_prog64() {
    logmsg "Making $PROG"
    cd $TMPDIR/$BUILDDIR
    PATH="$PREFIX/go/bin:$GOPATH/bin:$PATH" gmake build-illumos || logerr "Build failed"
}

make_install64() {
    cd $TMPDIR
    mkdir -p $DESTDIR/$PREFIX
    logmsg "Getting mattermost ($VER)"
    logcmd wget https://releases.$PROG.com/$VER/$PROG-team-$VER-linux-amd64.tar.gz \
        || logerr "Cannot get mattermost $VER"
    logcmd gtar xvf $PROG-team-$VER-linux-amd64.tar.gz -C $DESTDIR/$PREFIX \
        || logerr "Cannot extract mattermost $VER"
    logcmd cp $TMPDIR/$PROG/bin/platform $DESTDIR/$PREFIX/$PROG/bin \
        || logerr "Cannot copy platform to $DESTDIR"
    logmsg "Creating config path"
    logcmd mkdir -p $DESTDIR/etc/$PREFIX/$PROG || logerr "Cannot create config path"
    logcmd mv $DESTDIR/$PREFIX/$PROG/config/config.json $DESTDIR/etc/$PREFIX/$PROG \
        || logerr "Cannot move mattermost config"
    logcmd rm -rf $DESTDIR/$PREFIX/$PROG/config
    logmsg "--- Copying SMF manifest"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/social
    logcmd cp $SRCDIR/files/mattermost.xml $DESTDIR/lib/svc/manifest/social
}

init
download_git
#download_source $DLDIR v$VER '' $TMPDIR/$PROG/src/$MIRROR
#BUILDDIR=$PROG/src/$MIRROR/platform-$VER patch_source
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
