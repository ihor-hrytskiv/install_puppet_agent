#!/bin/bash
### Settings
TMP_DIR="/tmp/"
PACKAGES_LOCATION="https://apt.puppetlabs.com/"
PUPPET_PACKAGE=""

### Getting OS Distrib
if [ -f /etc/lsb-release ]; then
	. /etc/lsb-release
	DIST="$DISTRIB_ID"
	DIST_VER="$DISTRIB_RELEASE"
	DIST_CODENAME="$DISTRIB_CODENAME"
else
	DIST="Unknown"
	DIST_VER="Unknown"
fi

###Adding the Puppet 5 Platform repository
if [ "$DIST" == "Ubuntu" ] && [ "$DIST_VER" == "16.04" ]; then
	PUPPET_PACKAGE="puppet5-release-$DIST_CODENAME.deb"
	echo -e "The distribution is Ubuntu 16.04\n"
	if [ $(dpkg-query -W -f='${Status}' puppet5-release 2>/dev/null | grep -c "ok installed") == 0 ]; then
		if [ -f /etc/apt/sources.list.d/puppet5.list ]; then
			rm /etc/apt/sources.list.d/puppet5.list
		fi
		addrepoonubuntu
	else
		if [ ! -f /etc/apt/sources.list.d/puppet5.list ]; then
			apt remove puppet5-release
			addrepoonubuntu
		else
			echo -e "The Puppet 5 Platform repository already added\n"
		fi
	fi
else
	echo -e "Unknown Linux distribution, the Puppet 5 Platform repository will not be added\n"
fi

###Addin the Puppet 5 Platform repository on Ubuntu
function addrepoonubuntu {
	echo -e "Adding the Puppet 5 Platform repository\n"
	cd "$TMP_DIR"
	wget "$PACKAGES_LOCATION$PUPPET_PACKAGE"
	dpkg -i "$PUPPET_PACKAGE"
	rm "$PUPPET_PACKAGE"
	apt update
}

###Installing the Puppet 5 Platform
if [ "$DIST" == "Ubuntu" ]; then
	if [ $(dpkg-query -W -f='${Status}' puppet-agent 2>/dev/null | grep -c "ok installed") == 0 ]; then
		echo -e "Installing the Puppet 5 Platform\n"
		apt-get install puppet-agent
		/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
		/opt/puppetlabs/bin/puppet agent --test
	else
		echo -e "The Puppet 5 Platform already installed\n"
	fi
fi
