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
topdir=cvs
version=1.11.23
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/non-gnu/cvs/source/stable/$version/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export LDFLAGS="-L${prefix}/${_libdir} -Wl,-rpath,${prefix}/${_libdir}"
export CC=cc
mipspro=1
ignore_deps="tgc_perl5"

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
    doc FAQ README NEWS COPYING* doc/*.pdf
    ${__rm} -f ${stagedir}${prefix}/${_infodir}/dir
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
