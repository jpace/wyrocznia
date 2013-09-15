#!/usr/bin/ruby -w
# -*- ruby -*-

require 'rubygems'
require 'logue/log'
require 'logue/loggable'
require 'test/unit'

STDOUT.sync = true
STDERR.sync = true

Logue::Log.set_widths(-15, 35, -35)
Logue::Log.quiet = true
Logue::Log.verbose = true

module Wyrocznia
  class TestCase < Test::Unit::TestCase
    include Logue::Loggable

    # Returns a list of instance methods, in sorted order, so that they are run
    # predictably by the unit test framework.

    class << self
      alias :unsorted_instance_methods :instance_methods
      
      def instance_methods b
        unsorted_instance_methods(true).sort
      end
    end

    def test_truth
      assert true
    end
  end
end
