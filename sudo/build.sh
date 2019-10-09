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
topdir=sudo
version=1.8.27
pkgver=1
source[0]=ftp://ftp.sudo.ws/pub/sudo/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=sudo-1.8.27-mapanon.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
configure_args+=(--sysconfdir=$prefix/${_sysconfdir} --with-logging=syslog --with-logfac=auth --with-editor=/bin/vi --with-env-editor --with-ignore-dot --with-insults --with-all-insults --with-rundir=/var/run/sudo --disable-rpath)

# Makefile expects to be run as root, bypass for package creation
export INSTALL_OWNER=""

topinstalldir=/
pkgdefprefix=${prefix:1}

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    clean stage
    setdir ${srcdir}/${topsrcdir}
    ${__make} install DESTDIR="$stagedir" INSTALL_OWNER=""

    doc BUGS HISTORY LICENSE README UPGRADE
    echo "$pkgdefprefix/${_sysconfdir}/sudoers config(suggest)" > $metadir/ops
    ${__rm} -f ${stagedir}${prefix}/libexec/*.la
    ${__mkdir} -p ${stagedir}/var/run/sudo
    chmod 700 ${stagedir}/var/run/sudo
    # Turn hardlink into symlink
    setdir ${stagedir}${prefix}/${_bindir}
    ${__rm} -f sudoedit
    ${__ln} -sf sudo sudoedit
    # Fix manpage locations
    setdir ${stagedir}${prefix}/${_mandir}
    ${__mv} man1m man8
    ${__mv} man4 man5
    setdir man5
    ${__mv} sudoers.4 sudoers.5 
    setdir ../man8
    for f in visudo sudo sudoedit; do
	${__mv} $f.1m $f.8
    done
    ${__rm} -f sudoedit.8
    ${__ln} -sf sudo.8 sudoedit.8
    setdir ${stagedir}${prefix}/${_sysconfdir}
    ${__rm} -f sudoers
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN ops"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
