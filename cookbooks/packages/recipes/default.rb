node[:packages].each do |p|
  package p
end

%w(packages::iptables packages::sshd ntp apache2).each do |recipe|
  include_recipe recipe
end

##
# Default disabling of webservers.
%w(apache2).each do |webserver|
  service webserver do
    supports :status => true, :restart => true, :reload => true
    action [:disable, :stop]
  end
end
