script_home = "/usr/local/bin"

directory script_home do
  recursive true
  mode 0755
end

%w(hostname).each do |file|
  remote_file File.join(script_home, "#{file}.rb") do
    source "#{file}.rb"
    mode 0755
  end
end

Dir.chdir(script_home) do
  system("git clone git://github.com/help/setup.git")
end
