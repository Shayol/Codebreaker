require 'spec_helper'

module Codebreaker
  describe Codebreaker do
    let(:game) { Game.new }
    before do
      game.start
    end


    it 'has a version number' do
      expect(Codebreaker::VERSION).not_to be nil
    end

    context "#start" do

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

      it "returns '++--' in case of two correctly positioned guesses and  numbers on wrong positions" do
        expect(game.compare('1212')).to eq('++--')
      end

      it "returns '++++' in case of correct guess" do
        expect(game.compare('1122')).to eq('++++')
      end

      it "changes @won from false to true" do
        expect{game.compare('1122')}.to change{game.instance_variable_get(:@won)}.from(false).to(true)
      end
    end

    context "#hint" do

      before do
        game.instance_variable_set(:@secret_code, '1234')
      end

      it "changes @hintUsed from false to true" do
        expect{game.hint}.to change{game.instance_variable_get(:@hintUsed)}.from(false).to(true)
      end

      it "prints one of secret code's numbers" do
        expect(game.hint).to match(/[#{game.instance_variable_get(:@secret_code)}]/)
      end
    end

    context "#valid?" do

      it "returns false if player enters number longer then secret_code" do
        expect(game.valid?('1'*(1 + Game::CODE_LENGTH))).to be_falsey
      end

      it "returns false if player enters number shorter then secret_code" do
        expect(game.valid?('1'*(Game::CODE_LENGTH - 1))).to be_falsey
      end

      it "returns false if player enters numbers different from secret_code range numbers" do
        expect(game.valid?('7'*Game::CODE_LENGTH)).to be_falsey
      end
    end

    context "#save" do
      it "saves game data" do
        expect(File).to receive(:open).with(Game::STATISTICS, "a+")
        game.save('Name')
      end
    end

    # context "#results" do
    #   it 'outputs previous statistics in case it exists' do
    #     expect(File).to receive(:read).with(Game::STATISTICS)
    #     game.results
    #   end
    # end
  end
end
