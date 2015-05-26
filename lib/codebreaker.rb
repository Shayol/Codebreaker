# require "codebreaker/version"
require 'yaml'

module Codebreaker
  class Game

    attr_reader :hintUsed, :turnsCount, :won

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
    end

    # def turn(answer)
    #   case answer
    #     # when @secret_code
    #     #   @won=true
    #     #   playAgain
    #     when 'h'
    #       puts hint
    #     when 'q'
    #       finish
    #     else
    #       puts compare(answer)
    #       checkTurnsCount
    #     end
    # end

    def valid? (answer)
      if (answer.length == CODE_LENGTH && answer.match(/[1-MAX_CODE_NUMBER]+/)) || answer == "h" || answer == "q" || ((answer == "y" || answer == "n" || answer == '') && (@turnsCount >= MAX_TURNS_COUNT || @won == true))
        return true
      else
        return false
      end
    end

    def compare(answer)
      feedback = ''
      @won=true if answer == @secret_code
      return "++++" if @won==true
      @copy = @secret_code.clone

      (0...CODE_LENGTH).each do |x|
        if @copy[x] == answer[x]
          feedback.prepend("+")
          @copy[x]="k"
        end
      end

      (0...CODE_LENGTH).each do |x|
        if @copy.chars.include? answer[x]
          feedback << "-"
          position = @copy.index(answer[x])
          @copy[position] = "k"
        end
      end
      feedback << "    #{@secret_code}"  #clean up this
      return feedback
    end

    def hint
      # return "Already used your hint." if @hintUsed == true
      @hintUsed=true
     "#{@secret_code.chars[Random.rand(5)]}"
    end

    def playAgain(play)
      # puts "One more game?(y/n)"
      # play = gets.chomp.downcase
      # start if play == "y"
      # finish if play == "n"
    end

    def checkTurnsCount
      @turnsCount = @turnsCount + 1
      "Guess #{@turnsCount}: "
      #playAgain if @turnsCount >= MAX_TURNS_COUNT
    end

    def finish(name='')
      # if @won==true
      #   puts "Enter your name to save result or just press enter to quit"
      #   name = gets.chomp.downcase
        return save(name) if name != ''
      # end
      exit
    end

    def save(name)
      f = File.open(STATISTICS, "a+") do |file|
        file.puts("#{name} ..... attempts: #{@turnsCount} .... used a hint: #{@hintUsed}")
      end
      return File.read(STATISTICS) if File.exist? STATISTICS
    end
  end
end

# a=Codebreaker::Game.new
# a.start
