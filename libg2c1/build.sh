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
topdir=libg2c1
version=1
pkgver=1
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
gcc=4.2.2
[ "$_os" = "irix53" ] && gcc=3.4.6
version=$gcc

reg prep
prep()
{
    : nothing to prep
}

reg build
build()
{
    : nothing to build
}

reg install
install()
{
    echo "BuildRequires: tgc_gcc $gcc"
    clean stage
    ${__mkdir} -p ${stagedir}${prefix}/$_libdir
    [ "$_os" = "irix62" ] && libsuffix=32
    (cd $prefix/gcc-$gcc/${_libdir}${libsuffix}; ${__tar} -cf - libg2c.so.1*) |
    (cd ${stagedir}${prefix}/${_libdir}; ${__tar} -xvpf -)
    
    # fix up relnotes
    ${__sed} -e "s/@@GCCVER@@/$gcc/" ${metadir}/relnotes > ${metadir}/relnotes.$_os.txt
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN relnotes.$_os.txt"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
