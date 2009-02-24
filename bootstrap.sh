#!/bin/sh

### remove gem dirs.
rm -rf /root/.gem && mkdir /root/.gem && chown 000 /root/.gem

### bootstrap with ruby.
apt-get update && apt-get install ruby ruby1.8-dev rubygems libopenssl-ruby1.8 libsqlite3-ruby build-essential git-core

### bootstrap with chef.
gem install rubygems-update && /var/lib/gems/1.8/bin/update_rubygems
gem install chef ohai --source http://gems.opscode.com --source http://gems.rubyforge.org

### Run chef solo.
cd /tmp/ && git clone git://github.com/retr0h/chef_solo_web_with_passenger.git && cd chef_solo_web_with_passenger
chef-solo -l debug -c config/solo.rb -j config/dna.json


exit 0
