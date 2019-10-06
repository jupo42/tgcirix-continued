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
topdir=libjpeg
version=6b
pkgver=10
source[0]=jpegsrc.v6b.tar.gz
# If there are no patches, simply comment this
patch[0]=jpeg-c++.patch
patch[1]=libjpeg-6b-arm.patch
patch[2]=libjpeg-6b-soname.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
check_ac=0
shortroot=1
mipspro=1
topsrcdir=jpeg-$version
configure_args=(--prefix=$prefix --disable-static --enable-shared)
export INSTALL="/usr/tgcware/bin/install -c -D"
export CC=cc
if [ "$_os" = "irix53" ]; then
    NO_RQS="-Wl,-no_rqs "
    mipspro=2
fi
export LDFLAGS="$NO_RQS-Wl,-rpath,/usr/tgcware/lib"

reg prep
prep()
{
    generic_prep
    setdir source
    [ "$_os" = "irix53" ] && ${__gsed} -i '/^LD=/ s;.*;LD="$LD -no_rqs";' ltconfig
}

reg build
build()
{
    generic_build
    setdir source
    LD_LIBRARY_PATH=$PWD ${__make} test
}

reg install
install()
{
    generic_install prefix
    doc README usage.doc
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
