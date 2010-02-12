desc "Rake's default task."
task :default => :test

desc "Run chef-solo cookbook(s)."
task :solo do
  sh "chef-solo -l debug -c config/solo.rb -j config/dna.json"
end

desc "Check that solo is setup and configured correctly"
task :check_solo_setup do
  # TODO: need to check first... As the initial install script was ran from Ruby 1.8 std and now server is configure with REE.
  `gem install ohai chef json`
end

namespace :ci do
  
  desc "Run a custom chef-solo cookbook"
  task :setup => :check_solo_setup do
    puts "Please supply HOSTNAME=xxx for the hostname that this will be" unless ENV["HOSTNAME"]
    puts "Setting up this machine as a CI server at #{ENV["HOSTNAME"]}"
    sh "chef-solo -l debug -c config/solo.rb -j config/ci/dna.json"
  end
  
  desc "Add CI project"
  task :add_project => :check_solo_setup do
    unless ENV["GIT_URL"] && ENV["PROJECT_NAME"]
      puts "Please supply GIT_URL=xxx and PROJECT_NAME=xxx for the project you would like to set up"
    end
    puts "Adding #{ENV["GIT_URL"]} as #{ENV["PROJECT_NAME"]}"
    sh "chef-solo -l debug -c config/solo.rb -j config/ci/add_project.json"
  end
end

desc "Test cookbook(s) syntax."
task :test do
  puts "** Testing your cookbooks for syntax errors"
  Dir[ File.join(File.dirname(__FILE__), "cookbooks", "**", "*.rb") ].each do |recipe|
    sh %{ruby -c #{recipe}} do |ok, res|
      if ! ok
        raise "Syntax error in #{recipe}"
      end
    end
  end
end