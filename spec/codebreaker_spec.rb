require 'spec_helper'

module Codebreaker
  describe Codebreaker do
    it 'has a version number' do
      expect(Codebreaker::VERSION).not_to be nil
    end
    context "#start" do
        let(:game) { Game.new }

        before do
          expect(game).to receive(:turn)
          game.start
        end

        it "initializes secret code" do
          expect(game.instance_variable_get(:@secret_code)).not_to be_empty
        end

        it "saves 4 numbers secret code" do
          expect(game.instance_variable_get(:@secret_code).size).to eq(4)
        end

        it "saves secret code with numbers from 1 to 6" do
          expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
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
    #   let(:game) { Game.new }
    #   before do
    #     allow(game).to receive(:hint){puts "1"}
    #     allow(game).to receive(:compare)
    #     allow(game).to receive(:checkTurnsCount)
    #     allow(game).to receive(:win){exit}
    #     allow(game).to receive(:finish){exit}
    #     allow(game).to receive(:gets) {"1234\n"}
    #     game.start
    #   end
    #   it "asks player to guess secret code" do
    #     expect { game.turn }.to output(/guess/).to_stdout
    #   end
    #   it "says how to qut game" do
    #     expect { game.turn }.to output("If you want to quit game - type 'q'\n").to_stdout
    #   end

    #   it "proposes to use a hint unless it was used already" do
    #     game.instance_variable_set(:@hintUsed, true)
    #     expect{ game.turn }.to output(/hint/).to_stdout
    #   end

    #   it "calls game.hint in case player choses it"
    #   it "receives player's guess"
    #   it "checks guess" do
    #     expec{ game.turn }.to output(/\-/).to_stdout
    #   end
    #   it "calls game.win in case of right guess"
    #   it "shows which numbers were guessed"
    #   it "calls game.checkTurnsCount unless player has won"
    # end

    context "#hint" do
      let(:game) { Game.new }
      before do
        allow(game).to receive(:turn)
        game.start
      end
      it "prints message that hint limit was exceeded unless hintUsed=false" do
        game.instance_variable_set(:@hintUsed, true)
        expect { game.hint }.to output("You've used your only hint already.\n").to_stdout
      end
      it "changes @hintUsed from false to true" do
        expect{game.hint}.to change{game.instance_variable_get(:@hintUsed)}.from(false).to(true)
      end
      it "prints one of secret code's numbers" do
        expect { game.hint }.to output(/["#{game.instance_variable_get(:@secret_code)}"]/).to_stdout
      end
    end

    context "#checkTurnsCount" do
      let(:game) { Game.new }
      before do
        allow(game).to receive(:turn)
        game.start
      end
      # it "decides if player can play again in case it didn't exceed the limit turnsCount" do
      #   game.instance_variable_set(:@turnsCount, 10)
      #   expect(game).to receive(:over)
      # end
      it "adds 1 to @turnsCount" do
        expect{game.checkTurnsCount}.to change{game.instance_variable_get(:@turnsCount)}.by(1)
      end
    end

    context "#over" do
      let(:game) { Game.new }
      before do
        allow(game).to receive(:turn)
        allow(game).to receive(:playAgain)
        game.start
      end
      it "prints loser message" do
        expect { game.over }.to output(/lost/).to_stdout
      end
    end

    context "#win" do
      let(:game) { Game.new }
      before do
        allow(game).to receive(:turn)
        allow(game).to receive(:playAgain)
        game.start
      end
      it "prints four '+'" do
        expect { game.win }.to output(/won/).to_stdout
      end
      it "changes @won from false to true" do
        expect{ game.win }.to change{game.instance_variable_get(:@won)}.from(false).to(true)
      end
    end

    context "#playAgain" do
      let(:game) { Game.new }
      before do
        expect(game).to receive(:gets) {"n\n"}
        allow(game).to receive(:start)
        allow(game).to receive(:finish)
      end
      it "asks to play again" do
        expect { game.playAgain }.to output(/one more game/).to_stdout
      end
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
