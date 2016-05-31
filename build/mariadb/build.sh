#!/usr/bin/bash
#
. ../../lib/functions.sh

MAJORVERSION=10.1
PROG=mariadb
VER=$MAJORVERSION.14
VERHUMAN=$VER
BUILDDIR=server-mariadb-$VER
PKG=oep/database/$PROG
SUMMARY="MariaDB - the free mysql fork (v$VER)"
DESC="$SUMMARY"

BUILDARCH=64    # or 64 or both ... for libraries we want both for tools 32 bit only
BUILD_DEPENDS_IPS=oep/developer/build/cmake
RUN_DEPENDS_IPS=          

init
pushd $TMPDIR
if false; then
  [ -d $BUILDDIR ] && rm -rf $BUILDDIR
  git clone -b mariadb-$VER --depth 1 --single-branch  git@github.com:MariaDB/server.git $BUILDDIR
  patch_source
  cd $BUILDDIR
  mkdir -p build
  # /opt/gcc-4.8.1/bin/gcc -march=native -Q --help=target
  CFLAGS="-O3 -D__sun -m64 -march=corei7-avx -I/opt/oep/include -I$TMPDIR/$BUILDDIR/build/lz4-r131/lib  -L$TMPDIR/$BUILDDIR/build/lz4-r131" 
  LDFLAGS="-m64 -L/opt/oep/lib/amd64 -L/usr/ccs/lib/amd64 -L$TMPDIR/$BUILDDIR/build/lz4-r131 -R/usr/ccs/lib/amd64 -R/opt/oep/lib/amd64 -R/opt/oep/${PROG}/lib/amd64"
  cd build
## we want lz4 compression in mariadb 10.1
  curl -L https://github.com/Cyan4973/lz4/archive/r131.tar.gz | gtar zfx -
  pushd lz4-r131/
  cmake cmake_unofficial \
  	-DCMAKE_C_FLAGS="$CFLAGS" \
	-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  	-DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
  	-DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
  	-DCMAKE_MODULE_LINKER_FLAGS="$LDFLAGS"
  make
  popd	

  cmake .. \
	-DCURSES_LIBRARY=/lib/amd64/libcurses.so \
	-DDISABLE_SHARED=ON \
	-DINSTALL_SQLBENCHDIR= \
	-DCMAKE_C_FLAGS="$CFLAGS" \
	-DCMAKE_CXX_FLAGS="$CFLAGS" \
	-DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
	-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	-DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
	-DCMAKE_MODULE_LINKER_FLAGS="$LDFLAGS" \
	-DCMAKE_INSTALL_PREFIX=/opt/oep/$PROG \
        -DCMAKE_REQUIRED_INCLUDES=$BUILDDIR/build/lz4-r131/lib \
	-DMYSQL_DATADIR=/var/opt/oep/$PROG/data \
	-DDEFAULT_SYSCONFDIR=/etc/opt/oep/$PROG \
	-DENABLE_DTRACE=OFF \
	-DWITH_EXTRA_CHARSETS=complex \
	-DWITH_READLINE=ON \
	-DWITH_MAX=ON \
	-DWITH_EMBEDDED_SERVER=ON \
	-DWITH_UNIT_TESTS=OFF \
	-DWITH_MAX_NO_NDB=AUTO \
	-DWITH_EMBEDDED_SERVER=ON \
	-DWITH_INNODB_LZ4=ON
  gmake
fi

prep_build
cd $TMPDIR/$BUILDDIR/build
gmake install DESTDIR=$DESTDIR
logcmd rm -rf $DESTDIR/opt/oep/$PROG/mysql-test

# create symbolic link to standard bin dir
logcmd mkdir -p $DESTDIR/opt/oep/bin
logcmd ln -s /opt/oep/$PROG/bin/mysql $DESTDIR/opt/oep/bin/mysql-$MAJORVERSION
# create symbolic link to man page
logcmd mkdir -p $DESTDIR/opt/oep/share/man/man1
logcmd ln -s /opt/oep/$PROG/share/man/man1/mysql.1 $DESTDIR/opt/oep/share/man/man1/mysql-$MAJORVERSION.1

                    
tgtdir=${DESTDIR}/lib/svc/manifest/oep/database
logcmd mkdir -p ${tgtdir}
logcmd install -m 0444 ${SRCDIR}/$PROG.xml ${tgtdir}/ || logerr 'manifest install failed'
# add config
logcmd mkdir -p ${DESTDIR}/etc/opt/oep/${PROG}
logcmd mkdir -p ${DESTDIR}/var/log/${PROG}
logcmd install -m 0444 ${SRCDIR}/my.cnf ${DESTDIR}/etc/opt/oep/${PROG}
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
