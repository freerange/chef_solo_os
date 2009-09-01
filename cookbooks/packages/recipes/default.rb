node[:packages].each do |p|
  package p
end

%w(packages::iptables packages::sshd ntp apache2 nginx).each do |recipe|
  include_recipe recipe
end
