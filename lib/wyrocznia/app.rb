#!/usr/bin/ruby -w
# -*- ruby -*-

# integrate with http://www.thefreedictionary.com/rankle for word lists

require 'rainbow'
require 'wyrocznia/wordlist'
require 'wyrocznia/utils'

module Wyrocznia
  class App
    def initialize out, args
      nletters = args.shift.to_i.nonzero? || 2
      ndots = args.shift.to_i.nonzero? || (1 + (nletters == 3 ? rand(nletters - 1) : 0))

      fname = nletters == 2 ? "twos.txt" : "threes.txt"
      resdir = Wyrocznia::Utils.resource_directory
      fullname = resdir + fname

      wordlist = WordList.new fullname, nletters

      puts "Press ctrl-D to end ..."
      while wordlist.run_test(ndots)
      end
    end
  end
end
