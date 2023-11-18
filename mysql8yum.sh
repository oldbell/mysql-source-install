#!/bin/bash

 
#-- mysql 8.x on CentOS-7 --#

yum -y upgrade
yum -y update

# 환경
# yum -y install devtoolset-8-gcc.x86_64 devtoolset-8-gcc-c++.x86_64 devtoolset-8-make.x86_64 install devtoolset-8-binutils-devel.x86_64 devtoolset-8-build.x86_64

yum -y install wget.x86_64

# DWITH_LIBWRAP 옵션을 위해 필요함
yum -y install tcp_wrappers-devel.x86_64 tcp_wrappers-libs.x86_64 libcurl-devel.x86_64 

yum -y install openssl-devel.x86_64 openssl.x86_64 centos-release-scl libtirpc libtirpc-devel libgudev1-devel.x86_64 ncurses-devel.x86_64
yum -y install bzip2 bzip2-devel.x86_64
yum -y install devtoolset-11-gcc.x86_64 devtoolset-11-binutils-devel.x86_64 devtoolset-11-gcc-c++.x86_64 devtoolset-11-make-devel.x86_64 devtoolset-11-build.x86_64


# yum -y install wget ncurses-devel gcc* openssl openssl-devel python-devel centos-release-scl libtirpc libtirpc-devel devtoolset-8-gcc devtoolset-8-gcc-c++ libgudev1-devel.x86_64 

if [ -e "/opt/rh/devtoolset-11/enable" ];
then
        #scl enable devtoolset-11 bash
        source /opt/rh/devtoolset-11/enable
fi