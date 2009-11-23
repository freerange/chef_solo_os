#!/usr/bin/env ruby
#
# Set system hostname.

require 'rubygems'
require 'ohai'

@hostname = ARGV[0]
raise "Usage: #{$0} <hostname>\n" unless @hostname

def File.write(file, data)
  File.open(file,'w') {|f| f.write(data)}
end

def ohai
  @ohai ||= Ohai::System.new
  @ohai.all_plugins
  @ohai
end

case ohai[:platform]
when 'ubuntu'
  hosts = String.new
  File.open('/etc/hosts', 'r') do |f|
    while line = f.gets
      if line.match(/(127.0.0.1 localhost)/)
        hosts << "#{$1} #{@hostname}\n"
      else
        hosts << line
      end
    end
  end
  File.write('/etc/hostname', @hostname.chomp)
  File.write('/etc/hosts', hosts)
  case ohai[:platform_version]
  when '9.10'
    system("hostname -F /etc/hostname")
  else
    system("/etc/init.d/hostname.sh start")
  end
end
