#!/usr/bin/env ruby
#
# Originally inspired by Felipe: http://gist.github.com/102278

require 'rubygems'
require 'octopi'
require 'choice'

include Octopi

Choice.options do
  header ''
  header 'options:'

  option :phrase do
    short '-p'
    long '--passphrase=PHRASE'
    desc 'Passphrase to be used to create you SSH key'
  end

  option :user do
    short '-u'
    long '--user=USER'
    desc 'Your GitHub user name'
  end

  option :token do
    short '-t'
    long '--token=TOKEN'
    desc 'Your GitHub token'
  end

  option :email do
    short '-e'
    long '--email=EMAIL'
    desc 'The email to be used with git'
  end

  option :name do
    short '-n'
    long '--name=NAME'
    desc 'Name to be used with git'
  end
end

key = "#{ENV['HOME']}/.ssh/id_rsa"
pubkey = "#{key}.pub"
if !File.exist?(pubkey)
  `ssh-keygen -t rsa -N "#{Choice.choices[:phrase]}" -f #{key}`
end

gitconfig = "#{ENV['HOME']}/.gitconfig"
if !File.exist?(gitconfig)
  if not Choice.choices[:user] or not Choice.choices[:token]
    raise "Missing #{gitconfig}. Use ghkey --help to see options on how to create one."
  end

  `git config --global github.user #{Choice.choices[:user]}`
  `git config --global github.token #{Choice.choices[:token]}`

  `git config --global user.name #{Choice.choices[:name]}` if Choice.choices[:name]
  `git config --global user.email #{Choice.choices[:email]}` if Choice.choices[:email]
end

authenticated do |g|
  sshkey = File.open(pubkey, 'r') { |f| f.read }
  g.user.add_key `hostname`, sshkey
end

