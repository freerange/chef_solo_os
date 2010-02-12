#
# Cookbook Name:: CI Joe
# Recipe:: default
#
# Author:: Free Range (lets@gofreerange.com)
#
# This cookbook installs CI

# include for resource restarting
# include_recipe "apache2" # not working

# install cijoe gem into REE
ree_gem 'cijoe', :source => "http://gemcutter.org"

# set up apache to ready it to load applications that are setup
ci_path = node[:ci][:path]
hostname = ENV["HOSTNAME"].downcase

# set up CI Path location
directory ci_path do
  owner "www-data"
  group "www-data"
  action :create
end

# copy across Site vhost template
template "/etc/apache2/sites-available/#{hostname}" do
  source "apache_site.vhost.erb"
  variables(
    :hostname => hostname,
    :ci_path => ci_path
  )
  action :create
end

# set up vhosts directory
directory "#{ci_path}/vhosts" do
  action :create
  owner "www-data"
  group "www-data"
end

# enable CI site and restart apache
execute "Enable CI apache vhost site" do
  command "/usr/sbin/a2enmod #{hostname}"
  #notifies :reload, resources(:service => "apache2") # couldn't get working
end

# reload apache2
execute "Reload Apache2" do
  command "/etc/init.d/apache2 restart"
end

# setup HTTP Basic auth username and passwords
remote_file "#{ci_path}/auth.passwd" do
  source "auth.passwd"
  owner "www-data"
  group "www-data"
  action :create
end

# setup default index page
template "#{ci_path}index.html" do
  source "index_path.html.erb"
  variables(
    :hostname => hostname
  )
  owner "www-data"
  group "www-data"
  action :create
end