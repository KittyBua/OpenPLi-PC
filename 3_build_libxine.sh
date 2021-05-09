#!/bin/bash

# Build and install xine-lib:
LIB="libxine2"
PKG="xine-lib-1.2-1.2.10+hg-e2pc"
I=`dpkg -s $LIB | grep "Status"`

# Remove old package libxine2.
if [ -n "$I" ]; then
	apt-get -y purge libxine2*
else
	echo "$LIB not installed"
fi

# Remove old source libxine2.
if [ -d $PKG ]; then
	rm -rf $PKG
else
	rm -f $PKG
fi

# This is hg 1.2.10
wget http://hg.code.sf.net/p/xine/xine-lib-1.2/archive/17acda05716e.tar.bz2
tar -xvjf 17acda05716e.tar.bz2
rm 17acda05716e.tar.bz2
mv xine-lib-1-2-17acda05716e $PKG

if [ -d "$PKG" ]; then
	echo "-----------------------------------------"
	echo "      head now on 14886:17acda05716e"
	echo "-----------------------------------------"
	cp -fv patches/xine-lib-1.2-14886:17acda05716e.patch $PKG
else
	echo "-----------------------------------------"
	echo "        CHECK INTERNET CONNECTION!"
	echo "-----------------------------------------"
fi

cd $PKG
patch -p1 < xine-lib-1.2-14886:17acda05716e.patch
echo "-----------------------------------------"
echo "       patch for xine-lib applied"
echo "-----------------------------------------"
dpkg-buildpackage -d -uc -us

cd ..
mv *.deb $PKG
rm -f xine-lib-1.2*

cd $PKG
dpkg -i *.deb
cd ..
