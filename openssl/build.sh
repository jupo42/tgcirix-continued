#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=openssl
version=0.9.7c
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=openssl-0.9.7c-shlib.patch
patch[1]=openssl-0.9.7c-Configure.patch
patch[2]=openssl-0.9.7c-doc.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

subsysconf=$metadir/subsys.conf

sover=3 # c = 3
abbrev_ver=$(echo $version|$SED -e 's/\.//g')
baseversion=$(echo $version|$SED -e 's/[a-zA-Z]//g')
specver="$(fix_ver $version)""$sover"

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
pkgname="$pkgprefix""openssl""$abbrev_ver"
name="OpenSSL library"

# Define script functions and register them
METHODS=""
reg() {
    METHODS="$METHODS $1"
}

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    $SED -e "s;@LIBDIR@;${prefix}/lib;g" Makefile.org > Makefile.new
    $MV -f Makefile.new Makefile.org

    ./config --prefix=$prefix --openssldir=$prefix/ssl shared

    major=$(grep ^SHLIB_MAJOR Makefile)
    minor=$(grep ^SHLIB_MINOR Makefile)
    $SED -e "s;${major};SHLIB_MAJOR=${baseversion};g" \
	-e "s;${minor};SHLIB_MINOR=${sover};g" Makefile > Makefile.new
    $MV Makefile.new Makefile
    $SED -e "s;${major};SHLIB_MAJOR=${baseversion};g" \
	-e "s;${minor};SHLIB_MINOR=${sover};g" Makefile.ssl > Makefile.new
    $MV Makefile.new Makefile.ssl
    $MAKE_PROG LIBSSL="-Wl,-rpath,$prefix/lib -L.. -lssl" LIBCRYPTO="-Wl,-rpath,/usr/local/lib -L.. -lcrypto" all build-shared
    $MAKE_PROG LIBSSL="-Wl,-rpath,$prefix/lib -L.. -lssl" LIBCRYPTO="-Wl,-rpath,/usr/local/lib -L.. -lcrypto" all link-shared do_irix-shared
}

reg install
install()
{
    setdir source
    $MAKE_PROG INSTALL_PREFIX=$stagedir LIBSSL="-Wl,-rpath,$prefix/lib -L.. -lssl" LIBCRYPTO="-Wl,-rpath,$prefix/lib -L.. -lcrypto" install
    setdir $stagedir$prefix/lib
    chmod a+x pkgconfig
    rmdir $stagedir$prefix/ssl/lib
    $MV $stagedir$prefix/ssl/man $stagedir$prefix
    setdir $stagedir$prefix/man
    for j in $($LS -1d man?)
    do
	cd $j
	for manpage in *
	do
	    if [ -L "${manpage}" ]; then
		TARGET=`$LS -l "${manpage}" | $AWK '{ print $NF }'`
		ln -snf "${TARGET}"ssl "${manpage}"ssl
		$RM -f "${manpage}"
	    else
		$MV "$manpage" "$manpage""ssl"
	    fi
	done
	cd ..
    done
}

reg pack
pack()
{
    # Create a depends file
    echo "sw.devel $pkgname"".sw.base $specver$pkgver $specver$pkgver" > $metadir/depends
    echo "sw.base $pkgname"".sw.shlib $specver$pkgver $specver$pkgver" >> $metadir/depends
    setdir $stagedir$topinstalldir/man      
    fix_man
    setdir $stagedir$topinstalldir
    create_idb
    create_spec
    # Fix pkgversion
    fixed=$(fix_ver $version-$pkgver)
    $SED -e "s;version ${fixed};version ${specver}${pkgver};g" $specfile > /tmp/spec
    $MV -f /tmp/spec $specfile
    make_dist
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN depends"
    clean distclean
}

###################################################
# No need to look below here
###################################################

reg all
all()
{
    for METHOD in $METHODS 
    do
	case $METHOD in
	     all*|*clean) ;;
	     *) $METHOD
		;;
	esac
    done

}

reg
usage() {
    echo Usage $0 "{"$(echo $METHODS | tr " " "|")"}"
    exit 1
}

OK=0
for METHOD in $*
do
    METHOD=" $METHOD *"
    if [ "${METHODS%$METHOD}" == "$METHODS" ] ; then
	usage
    fi
    OK=1
done

if [ $OK = 0 ] ; then
    usage;
fi

for METHOD in $*
do
    ( $METHOD )
done
