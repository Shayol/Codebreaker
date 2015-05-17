require "codebreaker/version"

module Codebreaker
  class Game
    def initialize
      @secret_code = ""
    end

    def start
      @secret_code = "1234"
    end
  end
end
