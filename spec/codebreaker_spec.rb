require 'spec_helper'

module Codebreaker
  describe Codebreaker do
    let(:game) { Game.new }

    it 'has a version number' do
      expect(Codebreaker::VERSION).not_to be nil
    end

    context "#start" do
        before do
          game.start
        end

        it "initializes secret code" do
          expect(game.instance_variable_get(:@secret_code)).not_to be_empty
        end

        it "saves 4 numbers secret code" do
          expect(game.instance_variable_get(:@secret_code).size).to eq(4)
        end

        it "saves secret code with numbers from 1 to 6" do
          expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]{4}/)
        end

        it "initializes @turnsCount with 0 value" do
          expect(game.instance_variable_get(:@turnsCount)).to eq(0)
        end

        it "initializes @hintUsed with false value" do
          expect(game.instance_variable_get(:@hintUsed)).to eq(false)
        end

        it "initializes @won with false value" do
          expect(game.instance_variable_get(:@won)).to eq(false)
        end

      end

    # context "#turn" do
    #   before do
    #     allow(game).to receive(:checkTurnsCount)
    #     game.instance_variable_set(:@secret_code, '1122')
    #     game.start
    #   end

    #   it "calls hint in case player choses it" do
    #     expect(game).to receive(:hint)
    #     game.turn('h')
    #   end

    #   it "calls finish in case user enters 'q'" do
    #     expect(game).to receive(:finish)
    #     game.turn('q')
    #   end

    #   it "compares user's guess with secret number" do
    #     expect(game).to receive(:compare)
    #     game.turn('1111')
    #   end
    # end

    context "#compare" do
      before do
        game.instance_variable_set(:@secret_code, '1122')
      end

      it "returns '----' in case of all numbers on wrong positions" do
        expect(game.compare('2211')).to eq('----')
      end

      it "returns '++' in case of same numbers on right and wrong positions" do
        expect(game.compare('1111')).to eq('++')
      end

      it "returns '+-' in case of one correctly positioned guess and same number on wrong position" do
        expect(game.compare('1331')).to eq('+-')
      end
    end

    context "#hint" do

      before do
        game.instance_variable_set(:@secret_code, '1111')
        game.start
      end

      it "changes @hintUsed from false to true" do
        expect{game.hint}.to change{game.instance_variable_get(:@hintUsed)}.from(false).to(true)
      end

      it "prints one of secret code's numbers" do
        expect(game.hint).to match(/[#{game.instance_variable_get(:@secret_code)}]/)
      end
    end

    context "#checkTurnsCount" do
      before do
        game.start
      end

      it "decides if player lost in case he exceeded the limit turnsCount" do
        game.instance_variable_set(:@turnsCount, 10)
        expect(game).to receive(:playAgain)
        game.checkTurnsCount
      end

      it "adds 1 to @turnsCount" do
        expect{game.checkTurnsCount}.to change{game.instance_variable_get(:@turnsCount)}.by(1)
      end
    end

    context "#playAgain" do

      it "ends game in case user enters 'n'" do
        allow(game).to receive(:gets).and_return("n\n")
        expect(game).to receive(:finish)
        game.playAgain
      end

      it "starts new game in case user enters 'y'" do
        allow(game).to receive(:gets).and_return("y\n")
        expect(game).to receive(:start)
        game.playAgain
      end
    end

    context "#finish" do
      before do
        allow(game).to receive(:exit)
        game.start
      end

      it "doesn't save player's data if player lost" do
        expect(game).not_to receive(:save)
        game.finish
      end

      it "saves player's data if player has won and entered his name" do
        game.instance_variable_set(:@won, true)
        allow(game).to receive(:gets).and_return('name')
        expect(game).to receive(:save)
        game.finish
      end

      it "quits game if player has won and made a choice not to save his data" do
        game.instance_variable_set(:@won, true)
        allow(game).to receive(:gets).and_return("")
        expect(game).not_to receive(:save)
        game.finish
      end
    end

    context "#save" do

      it "saves game data" do
        expect(File).to receive(:open).with(Game::STATISTICS, "a+")
        game.save('Name')
      end

      it 'outputs previous statistics in case it exists' do
        expect(File).to receive(:read).with(Game::STATISTICS)
        game.save('Name')
      end
    end
  end
end
