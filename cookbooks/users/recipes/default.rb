node[:users].each do |user|
  homedir = user[:homedir]
  shell   = user[:shell] || "/bin/zsh"

  ##
  # Create user.
  user user[:username] do
    comment user[:username]
    home homedir
    shell shell
  end

  ##
  # Create skel homedir.
  (user[:homedir].to_a << "#{homedir}/.ssh").each do |dir|
    directory dir do
      recursive true
      owner user[:username]
      group user[:username]
      mode (dir.include?('.ssh') ? 0700 : 0755)
    end
  end

  ##
  # Run user specific recipes.
  include_recipe "users::#{user[:username]}" if File.exists?(File.join(File.dirname(__FILE__), "#{user[:username]}.rb"))

  remote_file "#{homedir}/.ssh/authorized_keys" do
    source "#{user[:username]}_id_rsa.pub"
    mode 0400
    owner user[:username]
    group user[:username]
  end

  ##
  # Setup shell and rc files.
  remote = user[:skel] ? "#{shell.split(/\//)[-1]}rc" : "zshrc"
  source = user[:skel] || "zshrc"
  remote_file "#{homedir}/.#{remote}" do
    source source
    mode 0644
    owner user[:username]
    group user[:username]
  end
end
