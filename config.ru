require_relative "lib/codebreaker"

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
    if answer == 'new'
      initialize
      return "New game started."
    end
    return "Type 'new' to start new game." if !@game
    if @game.won
      @game.save(answer) unless answer == ''
      @game=nil
      return "Type 'new' to play more."
    end
    message = case answer
      when 'h'
        @game.hintUsed ? "Already used your hint." : "Hint: #{@game.hint}"
      when 'q'
        @game=nil
        "Type 'new' to start new game."
      else
        return "Something is wrong with your input" unless @game.valid? answer
        guess = @game.compare(answer)
        guess.prepend(@game.checkTurnsCount)
        if @game.turnsCount >= Codebreaker::Game::MAX_TURNS_COUNT
          @game=nil
          guess << "  Exceeded number of attempts. Enter 'new' for one more game"
        elsif @game.won
          guess << "  You won!!! Enter your name to save result or just press enter to quit"
          guess << "<hr>Results:<hr><p>"#{@game.results}"</p>"
        end
        guess
    end
    return message
    end

end

run App.new