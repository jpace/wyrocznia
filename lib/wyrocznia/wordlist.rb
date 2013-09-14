#!/usr/bin/ruby -w
# -*- ruby -*-

require 'wyrocznia/matchlist'

class Word
  attr_reader :word
  attr_reader :definition
  attr_reader :dictionary

  def initialize word, defn, dictionary
    @word = word
    @definition = defn
    @dictionary = dictionary
  end
end

# accepts a text file of the form:
# word: definition {dictionary}
class WordList
  LETTERS = ('a' .. 'z').to_a

  def initialize fname, nletters
    @nletters = nletters
    re = Regexp.new('^(' + ('\w' * nletters) + '):\s*(.*?)(?:\{(.*)\})?\s*$')
    
    @words = Hash.new
    IO.readlines(fname).each do |line|
      line.chomp!
      next unless md = re.match(line)
      word = Word.new md[1].downcase, md[2].strip, md[3]
      @words[word.word] = word
    end
  end

  def random_letter
    LETTERS[rand(LETTERS.size)]
  end
  
  def matching pat
    MatchList.new self, @words.keys.select { |word| word.index(pat) == 0 }
  end

  def definition word
    @words[word].definition
  end

  def pattern ndots = @nletters - 1
    loop do
      pat = Array.new
      (@nletters).times { pat << random_letter }
      while pat.count { |x| x == '.' } < ndots
        dot = rand(@nletters)
        pat[dot] = '.'
      end
      re = Regexp.new pat.join('')
      return re unless matching(re).empty?
    end
  end

  def run_test ndots
    prevpats = Array.new
    
    while true do
      pat = nil
      (0 .. 100).each do
        pat = pattern ndots
        unless prevpats.include? pat
          prevpats << pat
          prevpats.shift if prevpats.size > 10
          break
        end
      end

      words = matching pat
      return false unless words.run_test pat
    end
    true
  end
end

class TwoLetterWordList < WordList
  def initialize 
    super "twos.txt", 2
  end
end

class ThreeLetterWordList < WordList
  def initialize 
    super "threes.txt", 3
  end
end
