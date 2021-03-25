# https://serverfault.com/a/516919
require 'puppet'

module Puppet::Parser::Functions
  newfunction(:directory_exists, :type => :rvalue) do |args|
    if File.directory?(args[0])
      return true
    else
      return false
    end
  end
end