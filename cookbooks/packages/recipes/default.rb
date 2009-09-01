node[:packages].each do |p|
  package p
end

%w(packages::iptables packages::sshd ntp mysql::client mysql::server apache2 nginx).each do |recipe|
  include_recipe recipe
end
