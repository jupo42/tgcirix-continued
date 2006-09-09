#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=gimp
version=2.2.13
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gimp-2.2.10-norpath.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
[ "$_os" = "irix62" ] && ac_overrides="ac_cv_lib_socket_socket=no"
# Until a suitable gimp-print is available we need to disable printing
configure_args="$configure_args --disable-print"

reg prep
prep()
{
    generic_prep
    setdir source
    autoconf
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    # Irix 6.2 ksh dumps core with a segfault in this directory
    setdir source
    $GSED -i '/^SHELL/s|/bin/ksh|/usr/tgcware/bin/bash|' themes/Default/images/Makefile
    generic_install DESTDIR
    doc AUTHORS COPYING NEWS LICENSE libgimp/COPYING README
    $FIND ${stagedir} -name '*.la' | xargs -i $RM -f {}
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
