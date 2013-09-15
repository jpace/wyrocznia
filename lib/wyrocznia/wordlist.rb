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
    re = Regexp.new('^(' + ('\w' * nletters) + ')(?:\:\s*(.*?)(?:\{(.*)\})?\s*$)?')
    
    @words = Hash.new
    IO.readlines(fname).each do |line|
      line.chomp!
      next unless md = re.match(line)
      word = md[1].downcase 
      defn = md[2] && md[2].strip
      dict = md[3]
      @words[word] = Word.new word, defn, dict
    end
  end

  def random_letter
    LETTERS[rand(LETTERS.size)]
  end
  
  def matching pat
    @words.keys.select { |word| word.index(pat) == 0 }
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
end

class WordListTest
  def initialize wordlist, ndots
    @wordlist = wordlist
    @ndots = ndots
  end

  def run_single_test matchlist, pat
    puts "======================================================="
    # puts "(((words: #{words})))"

    printf "matching: '#{pat.source}': ".color('#33fafa')

    ans = gets
    return false unless ans
    ans.chomp!
    return false if ans.chomp == 'quit'

    answords = ans.split(%r{\s*[\s,]+\s*}).sort
    puts "answords: #{answords}"

    mlt = MatchListTest.new matchlist, @wordlist
    mlt.show_each pat, answords

    puts
    true
  end

  def run_test
    prevpats = Array.new
    
    while true do
      pat = nil
      (0 .. 100).each do
        pat = @wordlist.pattern @ndots
        unless prevpats.include? pat
          prevpats << pat
          prevpats.shift if prevpats.size > 10
          break
        end
      end

      matchlist = @wordlist.matching pat
      unless run_single_test matchlist, pat
        return false
      end
    end
    true
  end
end
