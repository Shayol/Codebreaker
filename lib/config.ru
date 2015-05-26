require_relative "codebreaker"

class App

  def initialize
    @game = Codebreaker::Game.new
    @game.start
  end

  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when "/" then Rack::Response.new(render("index.html.erb"))
    when "/update_guess"
      Rack::Response.new do |response|
        response.set_cookie("guess", @request.params["guess"])
        response.redirect("/")
      end
    else Rack::Response.new("Not Found", 404)
    end.finish
end

def render(template)
    path = File.expand_path("../#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def guess
    ask(@request.cookies["guess"])
  end

  def ask(answ)
    return if answ == nil
    answer = answ.chomp.downcase
    return "Something is wrong with your input" unless @game.valid? answer
    if @game.won == true
      @game.finish if answer == ''
    else
      @game.finish(answer)
    end
    message = case answer
      when 'h'
        return "Already used your hint." if @game.hintUsed == true
        hint = @game.hint
      when 'q'
        @game.finish
      when 'n'
        return "Enter your name to save result or just press enter to quit"
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

run App.new