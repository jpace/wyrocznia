#!/usr/bin/ruby -w
# -*- ruby -*-

class MatchList < Array
  def initialize wordlist, words
    super words
    @wordlist = wordlist
    @wrongs = Array.new
  end

  def show_missing answords
    notfound = self - answords
    puts "notfound: #{notfound}"

    if notfound.empty?
      puts "all found".color('#33ff44')
    else
      puts "NOT FOUND"
      notfound.each do |nf|
        puts "    #{nf}: #{@wordlist.definition(nf)}".bright
      end
    end
  end

  def show_invalid answords
    invalid = answords - self
    puts "invalid : #{invalid}"

    if invalid.empty?
      puts "no invalid".color('#33ff44')
    else
      puts "INVALID"
      invalid.each do |wr|
        puts "    #{wr}".bright
      end
    end
  end

  def show_score answords
    notfound = self - answords
    invalid = answords - self
    score = length - notfound.length - invalid.length
    nwords = length
    puts "nwords  : #{nwords}".color('#fafa33')
    puts "score   : #{score}".color('#fafa33')
  end

  def print_word word, color, defn = false
    msg = "    "
    msg << word.color(color)
    if defn
      msg << " " << @wordlist.definition(word)
    end
    puts msg
  end

  def show_each pat, answords
    allwords = self | answords
    puts "allwords: #{allwords}"
    wrongs = Array.new
    allwords.sort.each do |w|
      if include? w
        if answords.include? w
          print_word w, '#33fa33'
        else
          print_word w, '#fa8833', true
          wrongs << w
        end
      else
        print_word w, '#fa3333'
      end
    end

    unless wrongs.empty?
      @wrongs << { pattern: pat, missed: wrongs }
    end
  end

  def show_brief pat, answords
    show_missing pat, answords
    show_invalid pat, answords
    show_score pat, answords
  end

  def run_test pat
    puts "======================================================="
    # puts "(((words: #{words})))"

    printf "matching: '#{pat.source}': ".color('#33fafa')

    ans = gets.chomp
    return false if ans == 'quit'

    answords = ans.split(%r{\s*[\s,]+\s*}).sort
    puts "answords: #{answords}"

    show_each pat, answords

    puts
  end
end
