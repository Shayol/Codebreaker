require_relative "codebreaker/version"
require 'yaml'

module Codebreaker
  class Game

    attr_reader :hintUsed, :turnsCount, :won

    CODE_LENGTH=4
    MAX_CODE_NUMBER=6
    MAX_TURNS_COUNT=10
    STATISTICS = "stat.txt"

    def start
      @secret_code = ""
      CODE_LENGTH.times{@secret_code << (1 + Random.rand(MAX_CODE_NUMBER)).to_s}
      @hintUsed=false
      @turnsCount=0
      @won=false
    end

    def valid? (answer)
      if answer.length == CODE_LENGTH && answer.match(/[1-MAX_CODE_NUMBER]{4}/)
        true
      else
        false
      end
    end

    def compare(answer)

      @won=true if answer == @secret_code
      return "++++" if @won==true

      @copy = @secret_code.clone
      feedback = ''
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
      return feedback
    end

    def hint
      @hintUsed=true
     "#{@secret_code.chars[Random.rand(CODE_LENGTH)]}"
    end

    def checkTurnsCount
      @turnsCount = @turnsCount + 1
      "Guess attempt #{@turnsCount}: "
    end

    def save(name)
      File.open(STATISTICS, "a+") do |file|
        file.puts("#{name} ..... attempts: #{@turnsCount} .... used a hint: #{@hintUsed}")
      end
    end

    def results
      "#{File.read(STATISTICS)}"
    end
  end
end

