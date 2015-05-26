#!/usr/bin/env ruby
require "../codebreaker"

module Interface

  def ask(answ)
    return if answ == nil
    answer = answ.chomp.downcase
    return "Something is wrong with your input" unless @game.valid? answer
    message = case answer
    when 'h'
      return "Already used your hint." if @game.hintUsed == true
      hint = @game.hint
    when 'q'
      @game.finish
    when 'y'
      @game = Codebreaker::Game.new
      @game.start
      return "New game."
    else
      guess = @game.compare(answer)
      guess.prepend(@game.checkTurnsCount)
      return guess << "  Exceeded number of attempts. One more game?(y/n)" if @game.turnsCount >= Codebreaker::Game::MAX_TURNS_COUNT
      return guess << "  You won!!! One more game?(y/n)" if @game.won == true
      return guess
    end
    return message
  end
end