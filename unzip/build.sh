#!/usr/didbs/current/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=unzip
version=5.52
pkgver=3
source[0]=${topdir}552.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global options
shortroot=1
[ "$_os" = "irix62" ] && mipspro=1
[ "$_os" = "irix53" ] && mipspro=2

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    ${__ln} -s unix/Makefile Makefile
    ${__make} sgi
}

reg install
install()
{
    generic_install prefix
    doc README BUGS LICENSE ToDo
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
