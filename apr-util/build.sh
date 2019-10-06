#!/usr/didbs/current/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=apr-util
version=1.3.9
pkgver=1
source[0]=http://mirrors.dotsrc.org/apache/apr/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=apr-util-1.3.7-no-nested-mutexes.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
apuver=1
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args+=(--disable-static --with-apr=${prefix} --includedir=${prefix}/${_includedir}/apr-${apuver} --with-expat=${prefix} --with-berkeley-db=${prefix} --with-iconv=${prefix} --with-ldap --with-ldap-include=${prefix}/${_includedir} --with-ldap-lib=${prefix}/${_libdir})

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
    setdir source
    ${__make} dox
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
    doc CHANGES LICENSE NOTICE
    ${__mkdir} -p ${stagedir}${prefix}/${_vdocdir}/html
    ${__install} -m 644 $srcdir/$topsrcdir/docs/dox/html/* ${stagedir}${prefix}/${_vdocdir}/html
    ${__rm} -f ${stagedir}${prefix}/${_libdir}/aprutil.exp
    ${__rm} -f ${stagedir}${prefix}/${_libdir}/apr-util-1/*.la
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
