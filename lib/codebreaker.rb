require "codebreaker/version"
#!/usr/bin/env ruby
# require_relative "codebreaker/Player"
require "codebreaker/Player"
require 'yaml'

module Codebreaker
  class Game

    CODE_LENGTH=4
    MAX_CODE_NUMBER=6
    MAX_TURNS_COUNT=10

    def start
      @secret_code = ""
      CODE_LENGTH.times{@secret_code << (1 + Random.rand(MAX_CODE_NUMBER)).to_s}
      @hintUsed=false
      @turnsCount=0
      @won=false
      turn
    end

    def turn
      # loop do
        puts "Try to guess secret code that consists of 4 numbers from 1 to 6."
        puts "You can use 1 hint. Put 'h' if you want to uncover one number" unless @hintUsed==true
        puts "If you want to quit game - type 'q'"
        answer = gets.chomp.downcase
        if (answer.length != CODE_LENGTH || !answer.match(/[1-MAX_CODE_NUMBER]+/)) && answer != "h" && answer != "q"
          puts "Check your input. Something is wrong."
          turn
        end
        case answer
          when 'h'
            hint
          when @secret_code
            win
          when 'q'
            finish
          else
            puts compare(answer)
            checkTurnsCount
          end
      # end
    end

    def compare(answer)
      feedback = ''
      @copy = @secret_code.clone
      # puts "#{@secret_code}---#{@copy}"
      (0..3).each do |x|
        if @copy[x] == answer[x]
          feedback.prepend("+")
          @copy[x]="k"

        elsif @copy.chars.include? answer[x]
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
        turn
      end
      @hintUsed=true
      return puts "#{@secret_code.chars[Random.rand(5)]}"
    end

    def win
      puts "You won!!! Answer is #{@secret_code}."
      @won=true
      playAgain
    end

    def playAgain
      puts "Press 'y' to play one more game"
      puts "Press 'n' to finish game"
      play = gets.chomp.downcase
      start if play == "y"
      finish if play == "n"
    end

    def checkTurnsCount
      @turnsCount = @turnsCount + 1
      puts "Guess № #{@turnsCount}"
      over if @turnsCount >= MAX_TURNS_COUNT
      turn
    end

    def over
      puts "Sorry, you lost. You exceeded maximum number of guesses."
      playAgain
    end

    def finish
      if @won==true
        puts "Do you want to save your name and result?(y/n)"
        saving = gets.chomp!
        save if saving=="y"
      end
      puts "Come play again someday. Good-bye!"
      exit
    end

    def save
      if File.exist? "rating.txt"
        serialized_object = File.read("rating.txt")
        players = YAML::load_stream(serialized_object)
        players.each{|player| puts "#{player.name}......#{player.count}"}
      end
      puts "Enter your initials:"
      name=gets.chomp
      user=Codebreaker::Player.new(name, @turnsCount)
      f = File.open("rating.txt", "a")
      f.write(YAML::dump(user))
      f.close
      return
    end
  end
end

# a=Codebreaker::Game.new
# a.start
