#!/usr/didbs/current/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=subversion
version=1.6.5
pkgver=1
source[0]=http://subversion.tigris.org/downloads/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args+=(--with-neon=${prefix} --with-apr=${prefix} --with-apr-util=${prefix} --without-jdk --disable-static)
[ "$_os" = "irix62" ] && ac_overrides="ac_cv_lib_socket_socket=no"

reg prep
prep()
{
    generic_prep
    setdir source
    #${__gsed} -i 's/la-file/libs/g' configure
    ${__gsed} -i 's/hardcode_into_libs=yes/hardcode_into_libs=no/g' configure
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
    doc CHANGES COPYING INSTALL README COMMITTERS BUGS
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
