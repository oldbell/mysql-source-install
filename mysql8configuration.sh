#!/bin/bash

dir_source="/opt/source"
dir_pkg_config="/usr/share/pkgconfig"
dir_ld_config="/etc/ld.so.conf.d"
# 
# mysql 설치하기 : https://downloads.mysql.com/archives/community/
#
# https://downloads.mysql.com/archives/get/p/23/file/mysql-8.0.31.tar.gz
#
#ver="8.2.0"
#gz="mysql-8.2.0-linux-glibc2.17-x86_64.tar.xz"
#tar="mysql-8.2.0-linux-glibc2.17-x86_64.tar"

#https://dev.mysql.com/get/Downloads/MySQL-8.2/mysql-8.2.0-linux-glibc2.17-x86_64.tar.xz
#https://dev.mysql.com/get/Downloads/MySQL-8.2/mysql-8.2.0-linux-glibc2.17-x86_64.tar.xz
#xz -d $gz
#tar -xvf $tar

cd $dir_source
ver="8.0.31"
name="mysql"
app="${name}-${ver}"
tar="${app}.tar"
gz="${tar}.gz"
if [ ! -e "${gz}" ];
then
    wget https://downloads.mysql.com/archives/get/p/23/file/$gz
fi
if [ ! -e "${tar}" ];
then
    gzip -d "$gz"
fi

if [ ! -e "${dir_source}/${app}" ];
then
    if [ -e "${tar}" ];
    then
        tar -xvf "${tar}"
    fi
fi

cd "${dir_source}/${app}"
rm -fR build/
mkdir build

cd build

# -DCMAKE_C_FLAGS_RELWITHDEBINFO="-O0 -g" -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-O0 -g" \
# -DOPTIMIZER_TRACE=1 \

cmake ../ \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql-8.0.31 \
-DMYSQL_DATADIR=/usr/local/mysql-8.0.31/data \
-DDOWNLOAD_BOOST=1 \
-DWITH_BOOST=/usr/local/boost \
-DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_TCP_PORT=3306 \
-DENABLE_DOWNLOADS=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_EXAMPLE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_INNODB_MEMCACHED=1 \
-DWITH_CURL=system \
-DWITH_SSL=system \
-DWITH_LIBWRAP=1 \
-DWITH_SYSTEMD=1  \
-DENABLED_PROFILING=1 \
-DWITH_ZLIB=bundled

make -j3
make install