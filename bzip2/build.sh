#!/usr/didbs/current/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=bzip2
version=1.0.6
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=bzip2-1.0.6-sane_soname.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

reg prep
prep()
{
    generic_prep
    # Add SGI version when building the shared library
    ${__gsed} -i '/soname/ s|-o|-Wl,-set_version,sgi1.0 -o|' Makefile-libbz2_so
}

reg build
build()
{
    setdir source
    ${__make} -f Makefile-libbz2_so CC="gcc -Wl,-rpath,/usr/tgcware/lib"
    ${__make} -f Makefile LDFLAGS="-Wl,-rpath,/usr/tgcware/lib"
}

reg install
install()
{
    clean stage
    setdir source
    ${__mkdir} -p ${stagedir}${prefix}/{${_bindir},${_mandir}/man1,${_libdir},${_includedir}}
    ${__install} -m 755 bzlib.h ${stagedir}${prefix}/${_includedir}
    ${__install} -m 755 libbz2.so.${version} ${stagedir}${prefix}/${_libdir}
    ${__install} -m 755 libbz2.a ${stagedir}${prefix}/${_libdir}
    ${__install} -m 755 bzip2-shared  ${stagedir}${prefix}/${_bindir}/bzip2
    ${__install} -m 755 bzip2recover bzgrep bzdiff bzmore ${stagedir}${prefix}/${_bindir}/
    ${__install} -m 644 bzip2.1 bzdiff.1 bzgrep.1 bzmore.1 ${stagedir}${prefix}/${_mandir}/man1/
    ${__ln} -s bzip2 ${stagedir}${prefix}/${_bindir}/bunzip2
    ${__ln} -s bzip2 ${stagedir}${prefix}/${_bindir}/bzcat
    ${__ln} -s bzdiff ${stagedir}${prefix}/${_bindir}/bzcmp
    ${__ln} -s bzmore ${stagedir}${prefix}/${_bindir}/bzless
    ${__ln} -s libbz2.so.${version} ${stagedir}${prefix}/${_libdir}/libbz2.so.1
    ${__ln} -s libbz2.so.1 ${stagedir}${prefix}/${_libdir}/libbz2.so
    ${__ln} -s bzip2.1 ${stagedir}${prefix}/${_mandir}/man1/bzip2recover.1
    ${__ln} -s bzip2.1 ${stagedir}${prefix}/${_mandir}/man1/bunzip2.1
    ${__ln} -s bzip2.1 ${stagedir}${prefix}/${_mandir}/man1/bzcat.1
    ${__ln} -s bzdiff.1 ${stagedir}${prefix}/${_mandir}/man1/bzcmp.1
    ${__ln} -s bzmore.1 ${stagedir}${prefix}/${_mandir}/man1/bzless.1

    doc LICENSE CHANGES README README.COMPILATION.PROBLEMS
    custom_install=1
    generic_install
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
