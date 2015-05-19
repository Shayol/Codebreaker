module Codebreaker
  class Player
    attr_reader :name, :count
    def initialize(name="anonim", count=0)
      @name=name
      @count=count
    end
  end
end