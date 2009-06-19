node[:packages].each do |p|
  package p
end

include_recipe "packages::iptables"
include_recipe "packages::sshd"
