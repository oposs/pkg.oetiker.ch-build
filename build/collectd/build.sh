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

PROG=collectd   # App name
VER=5.4.0       # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=system/collectd  # Package name (e.g. library/foo)
SUMMARY="collectd is a daemon which collects system performance statistics periodically and provides mechanisms to store the values in a variety of ways, for example in RRD files."      # One-liner, must be filled in
DESC="collectd gathers statistics about the system it is running on and stores this information. Those statistics can then be used to find current performance bottlenecks (i.e. performance analysis) and predict future system load (i.e. capacity planning). Or if you just want pretty graphs of your private server and are fed up with some homegrown solution you're at the right place, too ;)."

DOWNLOADURL=https://collectd.org/files/collectd-5.4.0.tar.bz2
BUILDARCH=32    # or 64 or both ... for libraries we want both for tools 32 bit only

BUILD_DEPENDS_IPS="database/rrdtool archiver/gnu-tar system/management/snmp/net-snmp library/libstatgrab"
RUN_DEPENDS_IPS="database/rrdtool library/libstatgrab system/management/snmp/net-snmp"
CPPFLAGS32="-I/opt/oep/include -I/opt/omni/include"
LDFLAGS32="-L/opt/oep/lib -R/opt/oep/lib -L/opt/omni/lib -R/opt/omni/lib"
LD_RUN_PATH=/opt/oep/lib:/opt/omni/lib
export LD_RUN_PATH

CONFIGURE_OPTS='--sysconfdir=/etc/opt/oep --localstatedir=/var/opt/oep'

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/system/collectd
    logcmd cp $SRCDIR/files/manifest-collectd.xml \
        $DESTDIR/lib/svc/manifest/system/collectd.xml
}
     
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
