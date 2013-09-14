#!/usr/bin/ruby -w
# -*- ruby -*-

# integrate with http://www.thefreedictionary.com/rankle for word lists

require 'rainbow'
$:.unshift File.dirname(__FILE__)
require 'wyrocznia/wordlist'

nletters = ARGV.shift.to_i.nonzero? || 2
ndots = ARGV.shift.to_i.nonzero? || (1 + (nletters == 3 ? rand(nletters - 1) : 0))
puts "ndots: #{ndots}"

wordlist = nletters == 3 ? ThreeLetterWordList.new : TwoLetterWordList.new

loop do
  break unless wordlist.run_test(ndots)
end
