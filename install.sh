#!/bin/bash
### Settings
TMP_DIR="/tmp/"
PACKAGES_LOCATION="https://apt.puppetlabs.com/"
UBUNTU_16_04_PACKAGE="puppet5-release-xenial.deb"

### Getting OS Distrib
if [ -f /etc/lsb-release ]; then
	. /etc/lsb-release
	DIST="$DISTRIB_ID"
	DIST_VER="$DISTRIB_RELEASE"
else
	DIST="Unknown"
	DIST_VER="Unknown"
fi

echo "$DISTRIB_ID"
echo "$DISTRIB_RELEASE"

###Adding the Puppet 5 Platform repository
if [ "$DIST" == "Ubuntu" ] && [ "$DIST_VER" == "16.04" ]; then
	echo "The distribution is Ubuntu 16.04"
	cd "$TMP_DIR"
	wget "$PACKAGES_LOCATION$UBUNTU_16.04_PACKAGE"
	dpkg -i "$UBUNTU_16.04_PACKAGE"
	apt update
else
	echo "Unknown Linux distribution, the Puppet 5 Platform repository will not be added"
fi
