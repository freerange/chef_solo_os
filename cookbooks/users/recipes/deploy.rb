bash "sudo_user" do
  code "usermod -G admin -a deploy"
end
