directory "/etc/apache2/sites-available" do
  mode 0775
  group "admin"
end
directory "/etc/apache2/sites-enabled" do
  mode 0775
  group "admin"
end
directory "/etc/apache2/ssl" do
  mode 0775
  group "admin"
end

# update rubygems
bash "Update Rubygems to latest version" do
  code "/opt/ruby-enterprise/bin/gem update --system"
end

ree_gem "bundler", :version => ">= 0.9.7"

# gems to run chef again
ree_gem "ohai"
ree_gem "chef"
ree_gem "json"

# chef needs libshadow-ruby which we need to install manually so it works with REE
remote_file "/usr/local/src/ruby-shadow-1.4.1.tar.gz" do
  source "http://ttsky.net/src/ruby-shadow-1.4.1.tar.gz"
  not_if { ::File.exists?("/usr/src/ruby-shadow-1.4.1.gz") }
end

bash "Install libshadow-ruby for REE" do
  cwd "/usr/local/src/"
  code <<-EOH
    tar zxf ruby-shadow-1.4.1.tar.gz
    cd /usr/local/src/shadow-1.4.1
    /opt/ruby-enterprise/bin/ruby extconf.rb; make; make install
  EOH
end