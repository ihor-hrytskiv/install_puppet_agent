#!/bin/bash
### Settings
TMP_DIR="/tmp/"
PACKAGES_LOCATION="https://apt.puppetlabs.com/"
PUPPET_PACKAGE=""

### Getting OS Distrib
if [ -n "$(command -v lsb_release)" ]; then
	DIST=$(lsb_release -s -i)
	DIST_VER=$(lsb_release -s -r)
	DIST_CODENAME=$(lsb_release -s -c)
else
	DIST="Unknown"
	DIST_VER="Unknown"
	DIST_CODENAME="Unknown"
fi

add_deb_repo () {
	echo -e "The distribution is $DIST\n"
        PUPPET_PACKAGE="puppet5-release-$DIST_CODENAME.deb"
        if [ "$(dpkg-query -W -f='${Status}' puppet5-release 2>/dev/null | grep -c "ok installed")" == 1 ] && [ ! -f /etc/apt/sources.list.d/puppet5.list ]; then
                echo -e "apt purge puppet5-release\n"
                sudo apt -y purge puppet5-release
        fi

        if [ "$(dpkg-query -W -f='${Status}' puppet5-release 2>/dev/null | grep -c "ok installed")" == 0 ]; then
                if [ -f /etc/apt/sources.list.d/puppet5.list ]; then 
                        echo -e "rm /etc/apt/sources.list.d/puppet5.list\n" 
                        sudo rm /etc/apt/sources.list.d/puppet5.list 
                fi 
                echo -e "Adding the Puppet 5 Platform repository\n"
                cd "$TMP_DIR"
                wget "$PACKAGES_LOCATION$PUPPET_PACKAGE"
                dpkg -i "$PUPPET_PACKAGE"
                rm "$PUPPET_PACKAGE"
                apt update
        else
                echo -e "The Puppet 5 Platform repository already added\n"
        fi
}

install_deb_package () {
	if [ "$(dpkg-query -W -f='${Status}' puppet-agent 2>/dev/null | grep -c "ok installed")" == 0 ]; then
                echo -e "Installing the Puppet 5 Platform\n"
                apt install puppet-agent
                /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
        else
                echo -e "The Puppet 5 Platform already installed\n"
        fi
}

###Adding the Puppet 5 Platform repository on Ubuntu
if [ "$DIST" == "Ubuntu" ] || [ "$DIST" == "Debian" ]; then
	add_deb_repo
else
	echo -e "Unknown Linux distribution, the Puppet 5 Platform repository will not be added\n"
fi

###Installing the Puppet 5 Platform on Ubuntu
if [ "$DIST" == "Ubuntu" ] || [ "$DIST" == "Debian" ]; then
	install_deb_package
fi
