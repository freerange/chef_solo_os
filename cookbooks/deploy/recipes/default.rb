directory @node["deploy"]["apache_vhost_directory"] do
  mode 0755
  owner "deploy"
  group "admin"
end

ree_gem "bundler", :version => ">= 0.9.7"