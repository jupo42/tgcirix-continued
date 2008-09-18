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
topdir=curl
version=7.19.0
pkgver=1
source[0]=http://curl.haxx.se/download/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=curl-7.17.1-pkgconfig.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
mipspro=1
export CC=cc
[ "$_os" = "irix53" ] && export CPP="cc -acpp -E"
[ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-static=no --enable-http --enable-ftp --enable-file --disable-ldap --enable-manual --disable-ipv6 --enable-cookies --enable-crypto --with-egd-socket=/var/run/egd-pool --with-libidn"
make_check_target="test"

reg prep
prep()
{
    generic_prep
    # We can't use inet_pton on Irix 6.2 even though it's in libc.
    setdir source
    ${__gsed} -i '/inet_pton \\/d' configure
    # Disable building/installing examples, they depend on snprintf
    ${__gsed} -i 's/examples//' docs/Makefile.in
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
    doc CHANGES COPYING README* RELEASE-NOTES docs/FAQ docs/FEATURES docs/BUGS \
      docs/MANUAL docs/RESOURCES docs/TODO docs/TheArtOfHttpScripting \
      docs/examples/*.c docs/examples/Makefile.example docs/INTERNALS \
      docs/CONTRIBUTE

    # Install libcurl.m4
    ${__install} -D -m 644 docs/libcurl/libcurl.m4 ${stagedir}${prefix}/${_sharedir}/aclocal/libcurl.m4
}

reg check
check()
{
    generic_check
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
