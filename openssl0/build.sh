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
topdir=openssl
version=0.9.8f
pkgver=7
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
ignore_deps="tgc_perl5.sw.base"
check_ac=0
__configure="./Configure"
configure_args=(--prefix=$prefix --openssldir=$prefix/ssl zlib shared)
if [ "$_os" == "irix53" ]; then
    configure_args+=(irix-cc)
    mipspro=2
fi
if [ "$_os" == "irix62" ]; then
    configure_args+=(irix-mips3-cc)
    mipspro=1
fi

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    $__configure "${configure_args[@]}"
    ${__gsed} -i '/^CFLAG=/s;.*=;CFLAG=-Olimit 3000 -I/usr/tgcware/include;' Makefile
    if [ "$_os" == "irix53" ]; then
	${__gsed} -i '/EX_LIBS/s;-lz;-Wl,-no_rqs -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -lz;' Makefile
	${__make} SHARED_LDFLAGS="-Wl,-no_rqs -Wl,-rpath,${prefix}/${_libdir}" depend
	${__make} SHARED_LDFLAGS="-Wl,-no_rqs -Wl,-rpath,${prefix}/${_libdir}"
    else
	${__gsed} -i '/EX_LIBS/s;-lz;-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -lz;' Makefile
	${__make} SHARED_LDFLAGS="-Wl,-rpath,${prefix}/${_libdir}" depend
	${__make} SHARED_LDFLAGS="-Wl,-rpath,${prefix}/${_libdir}"
    fi
}

reg install
install()
{
    clean stage
    setdir source
    ${__make} INSTALL_PREFIX=$stagedir MANDIR=${prefix}/${_mandir} install
    setdir ${stagedir}${prefix}/${_mandir}
    for j in $($LS -1d man?)
    do
        cd $j
        for manpage in *
        do
            if [ -L "${manpage}" ]; then
                TARGET=`$LS -l "${manpage}" | $AWK '{ print $NF }'`
                $LN -sf "${TARGET}"ssl "${manpage}"ssl
                $RM -f "${manpage}"
            else
                $MV "$manpage" "$manpage""ssl"
            fi
        done
        cd ..
    done
    doc README CHANGES FAQ INSTALL LICENSE NEWS
    custom_install=1
    generic_install INSTALL_PREFIX
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
