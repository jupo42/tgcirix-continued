#!/usr/didbs/current/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=libxml2
version=2.6.27
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export LDFLAGS="-L$prefix/lib -Wl,-rpath,$prefix/lib"
export CPPFLAGS="-I$prefix/include"
configure_args+=(--without-python)

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    doc README NEWS TODO TODO_SCHEMAS COPYING
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
