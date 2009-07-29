directory "/usr/local/bin" do
  recursive true
  mode 0755
end

remote_file "/usr/local/bin/ghkey.rb" do
  source "ghkey.rb"
  mode 0755
end
