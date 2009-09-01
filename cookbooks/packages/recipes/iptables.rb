package "iptables"

script "iptables_setup" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport ssh -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -A INPUT -j DROP
    sudo iptables -I INPUT 1 -i lo -j ACCEPT
    sudo iptables -I INPUT 5 -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7
  EOH
end

remote_file "/etc/network/if-post-down.d/iptasave" do
  source "iptasave"
  mode 0700
end

remote_file "/etc/network/if-pre-up.d/iptaload" do
  source "iptaload"
  mode 0700
end

bash "iptables_save" do
  code "/etc/network/if-post-down.d/iptasave"
end
