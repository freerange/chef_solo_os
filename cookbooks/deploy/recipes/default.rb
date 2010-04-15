directory "/etc/apache2/sites-available" do
  mode 0775
  group "admin"
end
directory "/etc/apache2/sites-enabled" do
  mode 0775
  group "admin"
end
directory "/etc/apache2/ssl" do
  mode 0775
  group "admin"
end