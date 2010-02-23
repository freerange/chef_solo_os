#
# Cookbook Name:: CI Joe
# Recipe:: default
#
# Author:: Free Range (lets@gofreerange.com)
#
# This cookbook adds a site

git_url = ENV["GIT_URL"]
project_name = ENV["PROJECT_NAME"]
ci_path = node[:ci][:path]

# clone the GIT repos into required location
execute "clone the repository into require project location" do
  command "git clone #{git_url} #{ci_path}/projects/#{project_name}/app"
end

# setup potentially required passenger directories
["#{ci_path}/projects/#{project_name}/public", "#{ci_path}/projects/#{project_name}/tmp"].each do |dir|
  directory dir do
    action :create
    owner "www-data"
    group "www-data"
  end
end

# set up config.ru
template "#{ci_path}/projects/#{project_name}/config.ru" do
  source "config.ru.erb"
  variables(:project_name => project_name)
  owner "www-data"
  group "www-data"
end

# add a new vhost for the project
template "#{ci_path}/vhosts/#{project_name}" do
  source "app.vhost.erb"
  variables(:project_name => project_name, :ci_path => ci_path)
  owner "www-data"
  group "www-data"
end

# add symbolic link for Rack/Passenger to see public folder
execute "add sym link to ci public folder" do
  command "ln -s #{ci_path}/projects/#{project_name}/public #{ci_path}/#{project_name}"
end

# reload apache2 config
execute "Restart Apache2" do
  command "/etc/init.d/apache2 reload"
end