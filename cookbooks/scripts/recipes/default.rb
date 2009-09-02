directory "/usr/local/bin" do
  recursive true
  mode 0755
end

%w(ghkey hostname).each do |file|
  remote_file "/usr/local/bin/#{file}.rb" do
    source "#{file}.rb"
    mode 0755
  end
end
