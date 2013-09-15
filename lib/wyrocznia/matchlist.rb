#!/usr/bin/ruby -w
# -*- ruby -*-

class MatchListTest
  def initialize matchlist, wordlist
    @matchlist = matchlist
    @wordlist = wordlist
    @wrongs = Array.new
  end

  def show_missing answords
    notfound = @matchlist - answords
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
    invalid = answords - @matchlist
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
    notfound = @matchlist - answords
    invalid = answords - @matchlist
    score = @matchlist.length - notfound.length - invalid.length
    nwords = @matchlist.length
    puts "nwords  : #{nwords}".color('#fafa33')
    puts "score   : #{score}".color('#fafa33')
  end

  def print_word word, color, showdef = false
    msg = "    "
    msg << word.color(color)
    if showdef && (defn = @wordlist.definition(word))
      msg << " " << defn
    end
    puts msg
  end

  def show_each pat, answords
    allwords = @matchlist | answords
    puts "allwords: #{allwords}"
    latest_wrongs = Array.new
    allwords.sort.each do |w|
      if @matchlist.include? w
        if answords.include? w
          print_word w, '#33fa33'
        else
          print_word w, '#fa8833', true
          latest_wrongs << w
        end
      else
        print_word w, '#fa3333'
      end
    end

    unless latest_wrongs.empty?
      @wrongs << { pattern: pat, missed: latest_wrongs }
    end
  end

  def show_brief pat, answords
    show_missing pat, answords
    show_invalid pat, answords
    show_score pat, answords
  end
end
