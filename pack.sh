#!/bin/bash

#pack utils

CURRENT_DIR=$(cd `dirname $0`; pwd)"/"
DIRLIST=(windows linux)
ZIPLIST=("component" "module")
PKGDIR=$CURRENT_DIR"pkg/"
PKGFILE=$CURRENT_DIR'pkg.cnf'

echo "clear pkg dir:${PKGDIR}"

if [ -d $PKGDIR ];then
	echo $PKGDIR
	rm -rf ${PKGDIR}/*
fi

#
pkginfo=''
for _dn in ${DIRLIST[@]}
do
	for _zn in "${ZIPLIST[@]}"
	do
		buildPath=${CURRENT_DIR}build/${_dn}/${_zn}/
		
		if [[ ! -d $buildPath ]];then
			continue;
		fi
		cd $buildPath
		scanDirs=(`ls $buildPath|tr "\n" " "`)
		for _fd in "${scanDirs[@]}"
		do

			if [[ ! -d "$_fd" ]];then
				continue;
			fi
			
			_zipname="${_dn}-${_zn}-${_fd}"
			zip -r9 -s=40000000  $_zipname ./$_fd
			ls ./|grep -e "${_zipname}.z" > "${_zipname}.cnf"
			mv -f ${_zipname}* $PKGDIR
			
			if [[ $pkginfo = '' ]];then
				pkginfo=${_zipname}
			else
				pkginfo=${pkginfo}"\n"${_zipname}
			fi
		done
	done
done
echo -e $pkginfo>$PKGFILE
