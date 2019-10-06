#!/usr/didbs/current/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=libidn
version=1.25
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/libidn/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
if [ "$_os" = "irix53" ]; then
    NO_RQS="-Wl,-no_rqs"
fi
mipspro=1
export CC=cc
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args+=(--disable-static)

reg prep
prep()
{
    generic_prep
    # "Fix" libtool
    setdir source
    ${__gsed} -i 's/fast_install=no/fast_install=yes/g' configure
}

reg build
build()
{
    generic_build
}

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
    doc README TODO NEWS COPYING* FAQ THANKS AUTHORS
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
