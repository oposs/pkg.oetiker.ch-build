#!/usr/bin/bash
. ../../lib/functions.sh

PROG=joe
VER=3.7
VERHUMAN=$VER
PKG=text/joe
SUMMARY="joe - Joe's own editor"
DESC="a very flexible editor"
MIRROR=sourceforge.net
DLDIR=projects/joe-editor/files/JOE%20sources/$PROG-$VER

BUILDARCH=32
CONFIGURE_OPTS_32="$CONFIGURE_OPTS_32"
init
download_source $DLDIR $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
