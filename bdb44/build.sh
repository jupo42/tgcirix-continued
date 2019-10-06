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
topdir=db
version=4.4.20
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=patch.4.4.20.1
patch[1]=patch.4.4.20.2
patch[2]=patch.4.4.20.3
patch[3]=patch.4.4.20.4

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CC=gcc
configure_args+=(--enable-compat185)
__configure="../dist/configure"
[ "$_os" = "irix62" ] && ac_overrides="ac_cv_lib_socket=no ac_cv_lib_socket_main=no"

patch_prefix=-p0

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build build_unix
}

reg install
install()
{
    generic_install DESTDIR build_unix
    doc LICENSE README
    $MV ${stagedir}${prefix}/docs/* ${stagedir}${prefix}/${_vdocdir}
    $RMDIR ${stagedir}${prefix}/docs
    setdir ${stagedir}${prefix}/${_libdir}
    $LN -sf libdb-4.4.a libdb.a
    setdir ${stagedir}${prefix}/${_includedir}
    $MKDIR db4
    $MV *.h db4
    for header in db4/*.h
    do
	$LN -s $header .
    done
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
