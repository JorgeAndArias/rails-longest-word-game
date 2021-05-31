class GamesController < ApplicationController
  class GamesController < ApplicationController

    def new
      @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    end

    def score
      @answer = params[:answer]
      block = params[:letters]
      @in_letter = @answer.upcase.chars.all? { |letter| @answer.upcase.chars.count(letter) <= block.count(letter) }
      dict_entry = load_json(@answer)
      @is_word = dict_entry['found']
      @score = 0

      if @in_letter && @is_word
        @result = "Congratualation! #{@answer} is a valid English word!"
        @score += 10
      elsif !@in_letter
        @result = "Sorry but #{@answer} can't be built out of #{block}."
      elsif !@is_word
        @result = "Sorry but #{@answer} does not seem to be a valid English word."
      end

      if session['score']
        session['score'] += @score
      else
        session['score'] = @score
      end

      @total_score = session['score']
    end

    def load_json(word)
      url = "https://wagon-dictionary.herokuapp.com/#{word}"
      dict_serialized = URI.open(url).read
      JSON.parse(dict_serialized)
    end
  end
end
