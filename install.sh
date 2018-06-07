#!/bin/bash
### Settings
TMP_DIR="/tmp/"
PACKAGES_LOCATION="https://apt.puppetlabs.com/"
XENIAL_PACKAGE="puppet5-release-xenial.deb"

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
	if [ ! -f /etc/apt/sources.list.d/puppet5.list ]; then
		echo "Adding the Puppet 5 Platform repository"
		cd "$TMP_DIR"
		wget "$PACKAGES_LOCATION$XENIAL_PACKAGE"
		dpkg -i "$XENIAL_PACKAGE"
		rm "$XENIAL_PACKAGE"
		apt update
	else
		echo "The Puppet 5 Platform repository already added"
	fi
else
	echo "Unknown Linux distribution, the Puppet 5 Platform repository will not be added"
fi

###Installing the Puppet 5 Platform
if [ "$DIST" == "Ubuntu" ]; then
	if [ $(dpkg-query -W -f='${Status}' puppet-agent 2>/dev/null | grep -c "ok installed") == 0]; then
		echo "Installing the Puppet 5 Platform"
		apt-get install puppet-agent
		/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
		/opt/puppetlabs/bin/puppet agent --test
	else
		echo "The Puppet 5 Platform already installed"
	fi
fi
