#script "add_rubygems_sources" do
#  interpreter "bash"
#  user "root"
#  code <<-EOH
#    gem source -a http://gems.rubyforge.org
#    gem source -a http://gems.github.com
#  EOH
#end

script "upgrade_rubygems" do
  interpreter "bash"
  user "root"
  code <<-EOH
    gem install rubygems-update --version=1.3.5 && /var/lib/gems/1.8/bin/update_rubygems
  EOH
end

##
# Taken from http://github.com/ezmobius/chef-101
node[:gems].each do |gem|
  gem_package gem[:name] do
    if gem[:version] && !gem[:version].empty?
      version gem[:version]
    end
    if gem[:source]
      source gem[:source]
    end
    action :install
  end
end
