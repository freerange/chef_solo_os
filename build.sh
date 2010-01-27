#!/bin/sh

trap "exit 2" 1 2 3 13 15

##
# Ubuntu.
if [ -f "/etc/lsb-release" ]; then
  ### Supported releases.
  #ISSUE="`awk '{print $2}' /etc/issue`"
  ISSUE="`awk -F"[ |.]" '{print $2$3}' /etc/issue`"
  case "${ISSUE}" in
    804) RELEASE="hardy" ;;
    810) RELEASE="intrepid" ;;
    904) RELEASE="jaunty" ;;
    910) RELEASE="karmic" ;;
    *) echo "[ERROR] Release '${ISSUE}' not supported!" && exit ;;
  esac

  ### Enable universe sources.
  sed -i -e 's/#deb/deb/g' /etc/apt/sources.list

  ### Add opscode sources to apt-get.
  echo "deb http://apt.opscode.com/ ${RELEASE} universe" > /etc/apt/sources.list.d/opscode.list
  wget -q -O - http://apt.opscode.com/packages@opscode.com.gpg.key | apt-key add - || exit 1
  apt-get update -y

  ### Upgrade all packages.
  apt-get upgrade -y --force-yes

  ### Install Git.
  apt-get install -y git-core

  ### Install Ruby.
  apt-get install -y ruby ruby1.8-dev libopenssl-ruby1.8 rdoc irb rubygems build-essential wget ssl-cert
  ### Add Rubygems bin path to $PATH
  export PATH=$PATH:/var/lib/gems/1.8/bin

  ### Add latest gem source.
  gem sources --add http://gemcutter.org
  gem sources --add http://gems.opscode.com

  ### No Docs.
  echo "gem: --no-user-install --no-rdoc --no-ri" > ${HOME}/.gemrc

  ### Install Chef
  gem install ohai chef json rake
  
  ### Run chef solo.
  cd /tmp && git clone git://github.com/freerange/chef_solo_os.git && cd /tmp/chef_solo_os || exit 1
  rake solo
else
  echo "[ERROR] OS unsupported."
fi


exit 0