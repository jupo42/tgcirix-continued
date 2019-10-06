#!/usr/didbs/current/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=curl
version=7.38.0
pkgver=1
source[0]=http://curl.haxx.se/download/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=curl-7.29.0-shutrdwr.patch
patch[1]=curl-7.24.0-testtrace-curlx.patch
patch[2]=curl-7.36.0-in_addr.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
mipspro=1
export CC=cc
if irix53; then
    NO_RQS="-Wl,-no_rqs"
fi
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args+=(--enable-static=no --enable-http --enable-ftp --enable-file --disable-ldap --enable-manual --disable-ipv6 --enable-cookies --enable-crypto --with-egd-socket=/var/run/egd-pool --with-libidn)
make_check_target="test"

reg prep
prep()
{
    generic_prep
    setdir source
    # We can't use inet_pton on Irix 6.2 even though it's in libc.
    ${__gsed} -i '/inet_pton \\/d' configure
    # getpwuid_r is not POSIX compliant on IRIX 5.3 but curl configure won't
    # leave well enough alone
    irix53 && ${__gsed} -i '/getpwuid_r \\/d' configure
    # Disable building/installing examples, they depend on snprintf
    ${__gsed} -i 's/examples//' docs/Makefile.in
    # "Fix" libtool
    ${__gsed} -i 's/fast_install=no/fast_install=yes/g' configure
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

    # Install curl binary
    # This is a terrible hack but libtool won't install it because libcurl
    # was not in its final destination :(
    ${__rm} -f ${stagedir}${prefix}/${_bindir}/curl
    ${__install} -D -m 755 src/.libs/curl ${stagedir}${prefix}/${_bindir}/curl
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
