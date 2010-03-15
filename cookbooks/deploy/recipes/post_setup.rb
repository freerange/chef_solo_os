ree_gem "bundler", :version => ">= 0.9.7"

# chef needs libshadow-ruby which we need to install manually so it works with REE
remote_file "/usr/local/src/ruby-shadow-1.4.1.tar.gz" do
  source "http://ttsky.net/src/ruby-shadow-1.4.1.tar.gz"
  not_if { ::File.exists?("/usr/src/ruby-shadow-1.4.1.gz") }
end

bash "Install libshadow-ruby for REE" do
  cwd "/usr/local/src/"
  code "tar zxf ruby-shadow-1.4.1.tar.gz"
  cwd "/usr/local/src/shadow-1.4.1"
  code "/opt/ruby-enterprise/bin/ruby extconf.rb; make; make install"
end