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
topdir=XML-Parser
version=2.34
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
maketest=1
perlpkgname="$(echo $pkgdir|sed -e 's/-/_/g')"
distfile='$pkgdir-$version-$pkgver.tgc-$os-$cpu-$pkgdirdesig.tardist'
__configure="perl"
configure_args=(Makefile.PL)

reg prep
prep()
{
    generic_prep
    chmod -R u+w $topsrcdir
}

reg build
build()
{
    generic_build_perl
}

reg install
install()
{
    generic_install_perl
    # Add docs
    doc samples README Changes
}

reg pack
pack()
{
    generic_pack_perl
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN pkgdef"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
