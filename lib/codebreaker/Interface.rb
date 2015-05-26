#!/usr/bin/env ruby
require "../codebreaker"

module Interface

  def ask(answ)
    return if answ == nil
    answer = answ.chomp.downcase
    if answer == 'new'
      initialize
      return "New game started."
    end
    return "Type 'new' to start new game." if !@game
    return "Something is wrong with your input" unless @game.valid? answer
    if @game.won
      answer == '' ? '' : @game.save(answer)
      return @game=nil
    end
    message = case answer
      when 'h'
        @game.hintUsed ? "Already used your hint." : "Hint: #{@game.hint}"
      when 'q'
        @game=nil
        "Type 'new' to start new game."
      else
        guess = @game.compare(answer)
        guess.prepend(@game.checkTurnsCount)
        guess << "  Exceeded number of attempts." if @game.turnsCount >= Codebreaker::Game::MAX_TURNS_COUNT
        guess << "  You won!!! Enter your name to save result or just press enter to quit" << "<p>#{@game.results}</p>" if @game.won
        guess
    end
    return message
    end
end