#!/bin/sh

if [ -f "/etc/lsb-release" ]; then
  ### remove gem dirs.
  rm -rf /root/.gem && mkdir /root/.gem && chown 000 /root/.gem

  ### bootstrap with ruby.
  apt-get update && apt-get upgrade
  apt-get install ruby ruby1.8-dev rubygems libopenssl-ruby1.8 libsqlite3-ruby irb build-essential
  gem install rubygems-update && /var/lib/gems/1.8/bin/update_rubygems
  rm /usr/bin/gem && ln -s /usr/bin/gem1.8 /usr/bin/gem

  ### bootstrap with chef.
  gem install chef ohai --source http://gems.opscode.com --source http://gems.rubyforge.org

  ### Run chef solo.
  chef-solo -l debug -c config/solo.rb -j config/dna.json
else
  echo "[ERROR] OS not supported yet."
fi


exit 0
