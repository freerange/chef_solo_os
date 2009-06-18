include_recipe "gems"
include_recipe "packages"
include_recipe "packages::iptables"
include_recipe "packages::sshd"

%w(bin sbin etc).each do |dir|
  directory "/opt/bitsugar/#{dir}" do
    recursive true
    mode 0755
  end
end
