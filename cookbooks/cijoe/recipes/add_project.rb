#
# Cookbook Name:: CI Joe
# Recipe:: default
#
# Author:: Free Range (lets@gofreerange.com)
#
# This cookbook adds a site

git_url = ENV["GIT_URL"]
project_name = File.basename(git_url.split("/").last, ".git")
ci_path = node[:ci][:path]
project_path = "#{ci_path}/projects/#{project_name}"

# clone the GIT repos into required location
execute "clone the repository into require project location" do
  command "git clone #{git_url} #{project_path}/app"
end

execute "touch a file for the log" do
  command "touch #{project_path}/site.log"
end

execute "update permissions so CI can run the build" do
  command "chown -R deploy:www-data #{project_path}/app"
end

# setup potentially required passenger directories
["#{project_path}/public", "#{project_path}/tmp"].each do |dir|
  directory dir do
    action :create
    owner "deploy"
    group "www-data"
  end
end

# set up config.ru
template "#{project_path}/config.ru" do
  source "config.ru.erb"
  variables(:project_path => project_path)
  owner "deploy"
  group "www-data"
end

# add a new vhost for the project
template "#{ci_path}/vhosts/#{project_name}" do
  source "app.vhost.erb"
  variables(:project_name => project_name, :ci_path => ci_path)
  owner "deploy"
  group "www-data"
end

# add symbolic link for Rack/Passenger to see public folder
execute "add sym link to ci public folder" do
  command "ln -s #{project_path}/public #{ci_path}/#{project_name}"
end

# create the database.yml file
template "#{project_path}/ci_database.yml" do
  source "ci_database.yml.erb"
  variables(:project_name => project_name)
  owner "deploy"
  group "www-data"
end

# Add the basic hook
template "#{project_path}/app/.git/hooks/after-reset" do
  source "after-reset"
  owner "deploy"
  group "www-data"
end

execute "Creating databases" do
  command "cd #{project_path}/app && rake db:create:all"
end

# add it to the listing
execute "Adding project to the root listing" do
  listing = File.join(ci_path, 'index.html')
  link = %{<a href="/#{project_name}">#{project_name}</a>}
  command %[ruby -e 'a=File.read("#{listing}");a.insert(a.index("</ul>"),%{<li>#{link}</li>});File.open("#{listing}", "w"){|f|f.write(a)}']
end

# reload apache2 config
execute "Restart Apache2" do
  command "/etc/init.d/apache2 reload"
end