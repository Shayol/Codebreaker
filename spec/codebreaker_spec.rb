require 'spec_helper'

module Codebreaker
  describe Codebreaker do
    it 'has a version number' do
      expect(Codebreaker::VERSION).not_to be nil
    end
    context "#start" do
        let(:game) { Game.new }

        before do
          game.start
        end

        it "saves secret code" do
          expect(game.instance_variable_get(:@secret_code)).not_to be_empty
        end

        it "saves 4 numbers secret code" do
          expect(game.instance_variable_get(:@secret_code).size).to eq(4)
        end

        it "saves secret code with numbers from 1 to 6" do
          expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
        end

        it "calls game.turn"
      end

    context "#turn" do
      before do
        game.turn
      end
      it "asks player to guess secret code"
      it "proposes to use a hint unless it was used already"
      it "calls game.hint in case player choses it"
      it "receives player's guess"
      it "checks guess"
      it "calls game.win in case of right guess"
      it "shows which numbers were guessed"
      it "calls game.checkTurnsCount unless player has won"
    end

    context "#hint" do
      before do
        game.hint
      end
      it "checks that its first time game.hint was called in this game"
      it "prints message that hint limit was exceeded unless hintUsed=false"
      it "prints one of secret code's numbers"
      it "calls game.turn"
    end

    context "#checkTurnsCount" do
      before do
        game.checkTurnsCount
      end
      it "checks how many guesses player's got already"
      it "decides if he can play again"
      it "adds 1 to turnsCount in case it didn't exceed the limit"
      it "calls game.over or game.turn"
    end

    context "#over" do
      before do
        game.over
      end
      it "prints loser message"
      it "calls game.playAgain"
    end

    context "#win" do
      before do
        game.win
      end
      it "prints four '+'"
      it "calls game.playAgain"
    end

    context "#playAgain" do
      it "asks to play again"
      it "receives answer and gives control to game.start or game.finish"
    end

    context "#finish" do
      before do
        game.finish
      end
      it "asks to save player's data and quits afterwards"
    end

    context "#save" do
      before do
        game.save
      end
      it "asks player initials"
      it "saves game data"
      it "calls game.finish"
    end
  end
end
