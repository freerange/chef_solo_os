node[:packages].each do |p|
  package p
end

%w(packages::iptables packages::sshd ntp).each do |recipe|
  include_recipe recipe
end
