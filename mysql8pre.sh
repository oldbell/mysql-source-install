#!/bin/bash


#-- mysql 8.x on CentOS-7 --#

dir_source="/opt/source"
dir_pkg_config="/usr/share/pkgconfig"
dir_ld_config="/etc/ld.so.conf.d"

# {{{ add_ldconfig : $0 /usr/local/arp-2.3.3
function add_ldconfig() 
{
    dir_so="$1/lib"
    if [ -e "${dir_so}" ];
    then
        fname="${1}.conf"
        ffname="${dir_ld_cojnfig}/${1}.conf"
        echo "${dir_so}" > "$ffname"
    fi
}
# }}}
# {{{ function add_pkg_config() : pkg_config 폴더의.pc값을 /usr/share/pkgconfig에 추가한다.
function add_pkg_config()
{
    target_path=$1
    target_pkg_config=${target_path}/lib/pkgconfig

    if [ ! -e "${target_pkg_config}" ];
    then
        return 0
    fi

    cnt=`echo $PKG_CONFIG_PATH | grep "${dir_pkg_config}" | wc -l`
    if [ $cnt -eq 0 -a -e "${dir_pkg_config}" ];
    then
        export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${dir_pkg_config}
        #echo "export PKG_CONFIG_PATH"
   fi

    for f in `find $target_pkg_config -name "*.pc"`
    do
        fname="${f##*/}"
        cnt=`find ${dir_pkg_config} -type f -name "${fname}" |wc -l |bc`
        if [ $cnt -eq 0 ];
        then
            #echo "cp -p $f $dir_pkg_config/"
            cp -p $f $dir_pkg_config/
        #else
            #echo "# -- can't found ${fname} in $dir_pkg_config $cnt"
            #echo "# -- check $dir_pkg_config"
            #find ${dir_pkg_config} -name "${f##*/}"
        fi
    done
}
# }}}
# {{{ function app_install() param : "name" "ext" "ver" "url" "config_param" "etc_param"
function app_install() 
{
    name="$1"
    ext="$2"
    ver="$3"
    url="$4"
    config_param="$5"

    app="${name}-${ver}"
    tar="${app}.tar"
    gz="${tar}.${ext}"
    target="/usr/local/${app}"
    target_pkg_config=${target}/lib/pkgconfig

    if [ ! -e "${dir_source}" ];
    then
        mkdir -p ${dir_source}
    fi

    cd $dir_source
    if [ -e "${target}" ];
    then
        echo "found $target"
        return
    fi

    if [ ! -e "${gz}" ];
    then
        wget -O "$gz" "$url"
    fi

    if [ ! -e "${tar}" ];
    then
        if [ "$ext" = "gzip" ];
        then
            gzip -d ${gz}
        fi

        if [ "$ext" = "gz" ];
        then
            gzip -d ${gz}
        fi

        if [ "$ext" = "bz2" ];
        then
            bzip2 -d ${gz}
        fi


        if [ "$ext" = "bzip" ];
        then
            bzip2 -d ${gz}
        fi

        if [ "$ext" = "xz" ];
        then
            xz -d ${gz}
        fi
    fi

    if [ ! -e "${app}" ];
    then
        tar -xvf ${tar}
    fi
    chown -R root:root ${app}

    if [ ! -e "${target}" ];
    then
        if [ ! -e "${app}" ];
        then
            echo "can't found ${dir_source}/${app}"
            return 0
        fi
        cd ${app}
        make clean
        ./configure --prefix=${target} $config_param
        make
        make install
        if [ -e "${target}" ];
        then
            ln -s ${target} /usr/local/${name}
        fi
    fi
    #add_pkg_config $target
    #add_ldconfig   $target
    add_pkg_config /usr/local/${name}
    add_ldconfig   /usr/local/${name}
}
# }}}


cd $dir_source
#name="libgd"
#ver="2.3.3"
#url="https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.gz"
#app_install $name "gz" "$ver" $url

# boost 1.81이 있지만 작동하지 않음
ver="1.77.0"
name="boost"
url="https://jaist.dl.sourceforge.net/project/boost/boost/1.77.0/boost_1_77_0.tar.bz2"
app_install $name "bz2" "$ver" $url

#bzip2 -d ./boost_1_77_0.tar.bz2
#tar -xvf boost_1_77_0.tar
#mv boost_1_77_0 /usr/local/boost

# {{{ # cmake 최신버전 설치하기 : https://cmake.org/download/
#
cd $dir_source
wget https://github.com/Kitware/CMake/releases/download/v3.25.2/cmake-3.25.2.tar.gz
gzip -d cmake-3.25.2.tar.gz
tar -xvf cmake-3.25.2.tar
cd cmake-3.25.2
./bootstrap 
make 
make install
cmake --version 
# }}}

# {{{ libtirpc 설치하기 ( 1.0 이상 이어야 함 )
ver="1.3.2"
name="libtirpc"
url="https://jaist.dl.sourceforge.net/project/libtirpc/libtirpc/1.3.2/libtirpc-1.3.2.tar.bz2"
app_install $name "bz2" "$ver" $url
#wget https://jaist.dl.sourceforge.net/project/libtirpc/libtirpc/1.3.2/libtirpc-1.3.2.tar.bz2
#bzip2 -d ./libtirpc-1.3.2.tar.bz2
#tar -xvf ./libtirpc-1.3.2.tar
#cd libtirpc-1.3.2
#./configure --prefix=/usr/local/libtirpc-1.3.2 
#make 
#make install
# }}}