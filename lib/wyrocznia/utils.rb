#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'

module Wyrocznia
  module Utils
    def self.resource_directory
      Pathname.new($0).expand_path.dirname.parent + 'resources'
    end
  end
end
