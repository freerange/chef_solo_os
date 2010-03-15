# Cookbook Name:: mongodb
# Recipe:: default

kernel = `uname -a`
package_tgz = case kernel
when kernel[/x86_64/] # 64 bit
  'mongodb-linux-x86_64-1.2.4.tgz'
else # 32 bit
  'mongodb-linux-i686-1.2.4.tgz'
end
package_folder = package_tgz.gsub('.tgz', '')

directory "/db/mongodb/master" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if { File.directory?('/db/mongodb/master') }
end

directory "/var/log/mongodb" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  not_if { File.directory?('/db/mongodb/master') }
end

directory "/db/mongodb/slave" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if { File.directory?('/db/mongodb/slave') }
end

execute "install-mongodb" do
  command %Q{
    curl -O http://downloads.mongodb.org/linux/#{package_tgz} &&
    tar zxvf #{package_tgz} &&
    mv #{package_folder} /usr/local/mongodb &&
    rm #{package_tgz}
  }
  not_if { File.directory?('/usr/local/mongodb') }
end

execute "add-to-path" do
  command %Q{
    echo 'export PATH=$PATH:/usr/local/mongodb/bin' >> /etc/profile
  }
  not_if "grep 'export PATH=$PATH:/usr/local/mongodb/bin' /etc/profile"
end

remote_file "/etc/init.d/mongodb" do
  source "mongodb"
  owner "root"
  group "root"
  mode 0755
end

execute "add-mongodb-to-default-run-level" do
  command %Q{
    update-rc.d mongodb defaults 99
  }
  not_if "rc-status | grep mongodb"
end

execute "ensure-mongodb-is-running" do
  command %Q{
    sudo /etc/init.d/mongodb start
  }
  not_if "pgrep mongod"
end