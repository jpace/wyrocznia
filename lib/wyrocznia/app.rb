#!/usr/bin/ruby -w
# -*- ruby -*-

# integrate with http://www.thefreedictionary.com/rankle for word lists
# integrate curl 'dict://dict.org/d:jete:*'

require 'rainbow'
require 'wyrocznia/wordlist'
require 'wyrocznia/utils'
require 'pathname'

module Wyrocznia
  class App
    def initialize out, args
      nletters = nil
      ndots = nil
      file = nil
      
      while arg = args.shift
        if Pathname.new(arg).file?
          file = arg
        else
          num = arg.to_i
          if nletters
            ndots = num
          else
            nletters = num
          end
        end
      end

      puts "file: #{file}"
      
      nletters ||= 2
      ndots ||= (1 + (nletters == 3 ? rand(nletters - 1) : 0))

      unless file
        fname = nletters == 2 ? "twos.txt" : "threes.txt"
        resdir = Wyrocznia::Utils.resource_directory
        file = resdir + fname
      end

      puts "file: #{file}"
      puts "ndots: #{ndots}"

      wordlist = WordList.new file, nletters
      puts "wordlist: #{wordlist}"
      tester = WordListTest.new wordlist, ndots

      puts "Press ctrl-D to end ..."
      nil while tester.run_test
    end
  end
end
