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
topdir=gtk+
version=1.2.10
pkgver=10
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=gtk+-1.2.10-bellvolume.patch
patch[1]=gtk+-1.2.10-clistfocusrow.patch
patch[2]=gtk+-1.2.10-deletedir.patch
patch[3]=gtk+-1.2.10-dndorder.patch
patch[4]=gtk+-1.2.10-expose.patch
patch[5]=gtk+-1.2.10-focus.patch
patch[6]=gtk+-1.2.10-localecrash.patch
patch[7]=gtk+-1.2.10-missingchar.patch
patch[8]=gtk+-1.2.10-pixmapref.patch
patch[9]=gtk+-1.2.10-themeswitch.patch
patch[10]=gtk+-1.2.10-troughpaint.patch
patch[11]=gtk+-1.2.6-ahiguti.patch
patch[12]=gtk+-1.2.8-wrap-alnum.patch
patch[13]=gtk+-underquoted.patch
patch[14]=gtk+-1.2.10-autoconf25x.patch
patch[15]=gtk+-1.2.10-newgt.patch
patch[16]=gtk+-1.2.10-kpenter.patch
patch[17]=gtk+-1.2.10-ctext.patch
patch[18]=gtk+-1.2.10-utf8fontset.patch
patch[19]=gtk+-1.2.10-gtkgdkdep.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CC=gcc
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args=(--prefix=$prefix --mandir=${prefix}/${_mandir} --infodir=${prefix}/${_infodir} --enable-static=no)
if [ "$_os" = "irix62" ]; then
    export CC=cc
    mipspro=1
    configure_args+=(--x-libraries=/usr/lib32)
fi

reg prep
prep()
{
    generic_prep
    setdir source
    ${__rm} -f ltconfig ltmain.sh acinclude.m4
    libtoolize -f -c
    aclocal-1.11
    automake-1.11 -a -f -c
    autoheader
    autoconf
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
    doc AUTHORS COPYING ChangeLog NEWS README TODO
    doc docs/html
    doc examples
    ${__mv} ${stagedir}${prefix}/${_vdocdir}/docs/html ${stagedir}${prefix}/${_vdocdir}
    ${__rmdir} ${stagedir}${prefix}/${_vdocdir}/docs
    irix62 && ${__gsed} -i 's|-L/usr/lib32||' ${stagedir}${prefix}/${_libdir}/pkgconfig/gdk.pc
    irix62 && ${__gsed} -i 's|-L/usr/lib32||' ${stagedir}${prefix}/${_bindir}/gtk-config
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
