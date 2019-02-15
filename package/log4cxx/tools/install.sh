#!/bin/sh -ex

if [ $# -ge 1 ]; then
  cd $1
fi

WORKDIR=ap2

rm -rf $WORKDIR
mkdir $WORKDIR

wget -N http://archive.apache.org/dist/apr/apr-1.5.2-win32-src.zip
unzip -o apr-1.5.2-win32-src.zip > /dev/null 2>&1
rm apr-1.5.2-win32-src.zip
mv apr-1.5.2 $WORKDIR/apr


wget -N http://archive.apache.org/dist/apr/apr-util-1.5.4-win32-src.zip
unzip -o apr-util-1.5.4-win32-src.zip > /dev/null 2>&1
rm apr-util-1.5.4-win32-src.zip
mv apr-util-1.5.4 $WORKDIR/apr-util

wget -N https://archive.apache.org/dist/logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.zip
unzip -o apache-log4cxx-0.10.0.zip > /dev/null 2>&1
rm apache-log4cxx-0.10.0.zip
mv apache-log4cxx-0.10.0 $WORKDIR/log4cxx


cd $WORKDIR/log4cxx
./configure-aprutil.bat
./configure.bat

sed -i "/#include <vector>/ a #include<iterator>" ../log4cxx/src/main/cpp/stringhelper.cpp
sed -i "/namespace log4cxx/ i #define DELETED_CTORS(T) T(const T&) = delete; T& operator=(const T&) = delete;\n\n#define DEFAULTED_AND_DELETED_CTORS(T) T() = default; T(const T&) = delete; T& operator=(const T&) = delete;\n" ../log4cxx/src/main/include/log4cxx/helpers/objectimpl.h
sed -i "/END_LOG4CXX_CAST_MAP()/ a \  DEFAULTED_AND_DELETED_CTORS(PatternConverter)" ../log4cxx/src/main/include/log4cxx/pattern/patternconverter.h
sed -i "/virtual ~RollingPolicyBase();/ i \          DELETED_CTORS(RollingPolicyBase)" ../log4cxx/src/main/include/log4cxx/rolling/RollingPolicyBase.h
sed -i "/virtual ~TriggeringPolicy();/ i \             DEFAULTED_AND_DELETED_CTORS(TriggeringPolicy)" ../log4cxx/src/main/include/log4cxx/rolling/TriggeringPolicy.h
sed -i "/Filter();/ a \                        DELETED_CTORS(Filter)" ../log4cxx/src/main/include/log4cxx/spi/Filter.h
sed -i "/virtual ~Layout();/ i \                DEFAULTED_AND_DELETED_CTORS(Layout)" ../log4cxx/src/main/include/log4cxx/Layout.h
sed -i -e "s/defined(_MSC_VER) \&\&/defined(_MSC_VER) \&\& _MSC_VER < 1600 \&\&/" ../log4cxx/src/main/include/log4cxx/log4cxx.h
