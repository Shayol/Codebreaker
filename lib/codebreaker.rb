require "codebreaker/version"
require 'yaml'

module Codebreaker
  class Game

    CODE_LENGTH=4
    MAX_CODE_NUMBER=6
    MAX_TURNS_COUNT=10
    STATISTICS = "lib/stat.txt"

    def start
      @secret_code = ""
      CODE_LENGTH.times{@secret_code << (1 + Random.rand(MAX_CODE_NUMBER)).to_s}
      @hintUsed=false
      @turnsCount=0
      @won=false
      turn
    end

    def turn
      puts "Guess 4 numbers in 1-6 range, hint(h), quit(q)"
      answer = gets.chomp.downcase
      turn if !valid? answer
      case answer
        when @secret_code
          @won=true
          playAgain
        when 'h'
          puts hint
        when 'q'
          finish
        else
          puts compare(answer)
          checkTurnsCount
        end
    end

    def valid? (answer)
      if (answer.length == CODE_LENGTH && answer.match(/[1-MAX_CODE_NUMBER]+/)) || answer == "h" || answer == "q"
        return true
      else
        puts "Check your input. Something is wrong."
        return false
      end
    end

    def compare(answer)
      feedback = ''
      @copy = @secret_code.clone
      puts "#{@copy}"
      (0..3).each do |x|
        if @copy[x] == answer[x]
          feedback.prepend("+")
          @copy[x]="k"
        end
      end

      (0..3).each do |x|
        if @copy.chars.include? answer[x]
          feedback << "-"
          position = @copy.index(answer[x])
          @copy[position] = "k"
        end
      end
      return feedback
    end

    def hint
      if @hintUsed==true
       puts "You've used your only hint already."
      else
      @hintUsed=true
      puts "#{@secret_code.chars[Random.rand(5)]}"
      end
      turn
    end

    def playAgain
      puts "You won!!!" if @won==true
      puts "One more game?(y/n)"
      play = gets.chomp.downcase
      start if play == "y"
      finish if play == "n"
    end

    def checkTurnsCount
      @turnsCount = @turnsCount + 1
      puts "Guess № #{@turnsCount}\n\n"
      playAgain if @turnsCount >= MAX_TURNS_COUNT
      turn
    end

    def finish
      if @won==true
        puts "Enter your name to save result or just press enter to quit"
        name = gets.chomp.downcase
        save(name) if name != '\n'
      end
      exit
    end

    def save(name)
      f = File.open(STATISTICS, "a+") do |file|
        file.puts("#{name} ..... attempts: #{@turnsCount} .... used a hint: #{@hintUsed}")
      end
      puts File.read(STATISTICS) if File.exist? STATISTICS
      return
    end
  end
end

# a=Codebreaker::Game.new
# a.start
