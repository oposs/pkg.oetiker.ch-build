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
#
# Copyright 1995-2013 OETIKER+PARTNER AG  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh
. ../myfunc.sh

PROG=check_mk_agent                         # App name
VER=1.2.6.2                                 # App version
VERHUMAN=$VER-1                             # Human-readable version
PKG=oep/network/check_mk_agent              # Package name (e.g. library/foo)
SUMMARY="Monitoring agent for check_mk."
DESC="${SUMMARY}"

RUN_DEPENDS_IPS=""
BUILD_DEPENDS_IPS=""

BUILDARCH=both

# package specific
MIRROR=raw.githubusercontent.com

download_source() {
    logmsg "Downloading Source"

    cd ${TMPDIR}
    wget -c https://$MIRROR/moetiker/check_mk_mirror/master/agents/check_mk_agent.solaris
}

build() {
    logmsg "--- building"
    logmsg "---- autodetecting version"
    #VER=$(grep -i "version:" ${TMPDIR}/check_mk_agent.solaris | awk '{ print $3 }' | sed 's/p/\./g')

    logmsg "---- fixing paths"
    #/usr/bin/gsed -i 's#MK_CONFDIR=\"/usr#MK_CONFDIR=\"opt/oep#' ${TMPDIR}/check_mk_agent.solaris
    #/usr/bin/gsed -i 's#MK_LIBDIR=\"/usr#MK_LIBDIR=\"/opt/oep#' ${TMPDIR}/check_mk_agent.solaris
}

make_install() {
    logmsg "--- make install"
    logcmd mkdir -p ${DESTDIR}${PREFIX}/ || \
        logerr "------ Failed to create destination directory."
    logcmd mkdir -p ${DESTDIR}${PREFIX}/bin || \
        logerr "------ Failed to create bin directory."
    logcmd mkdir -p ${DESTDIR}${PREFIX}/share/docs || \
        logerr "------ Failed to create docs directory."
    logcmd mkdir -p ${DESTDIR}/opt/etc/check_mk_agent || \
        logerr "------ Failed to create etc directory."
    logcmd mkdir -p ${DESTDIR}${PREFIX}/lib/check_mk_agent || \
        logerr "------ Failed to create config directory."
    logcmd mkdir -p ${DESTDIR}${PREFIX}/lib/check_mk_agent/plugins || \
        logerr "------ Failed to create plugins directory."
    logcmd mkdir -p ${DESTDIR}${PREFIX}/lib/check_mk_agent/local || \
        logerr "------ Failed to create local directory."
    logcmd mkdir -p ${DESTDIR}/var/opt/oep/lib/check_mk_agent/cache || \
        logerr "------ Failed to create local directory."
    logcmd mkdir -p ${DESTDIR}/var/opt/oep/lib/check_mk_agent/job || \
        logerr "------ Failed to create local directory."

    logcmd cp ${SRCDIR}/files/check_mk_agent ${DESTDIR}${PREFIX}/bin/check_mk_agent || \
        logerr "------ Failed to copy agent."
    logcmd chmod +x ${DESTDIR}${PREFIX}/bin/check_mk_agent || \
        logerr "------ Failed to make agent executable."

    logcmd cp ${SRCDIR}/files/mk_inventory ${DESTDIR}${PREFIX}/lib/check_mk_agent/plugins || \
        logerr "------ Failed to copy agent."
    logcmd chmod +x ${DESTDIR}${PREFIX}/lib/check_mk_agent/plugins/mk_inventory || \
        logerr "------ Failed to make agent executable."
    
    logcmd cp ${SRCDIR}/files/mk_inventory.cfg ${DESTDIR}/opt/etc/mk_inventory.cfg || \
        logerr "------ Failed to copy agent."

    logcmd mkdir -p ${DESTDIR}/lib/svc/manifest/network || \
        logerr "------ Failed to create svc directory."
    logcmd cp ${SRCDIR}/files/smf.xml ${DESTDIR}/lib/svc/manifest/network/check_mk.xml || \
        logerr "------ Failed to copy service framework manfest."

    logcmd cp ${SRCDIR}/files/docs.txt ${DESTDIR}${PREFIX}/share/docs/check_mk_agent.txt || \
        logerr "------ Failed to doc."
}

init
prep_build
patch_source
build
make_install
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
