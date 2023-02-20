require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = []
    generate_grid(8)
  end

  def score
    @guess = params[:word].upcase
    @grid = params[:grid]
    @valid_letters = included?(@guess, @grid)
    @valid_word = english_word?(@guess)
    @outcome = ''
    if @valid_letters
      if @valid_word
        @outcome = "Congratulations, #{@guess} is a valid enlish word"
      else
        @outcome = "#{@guess} is no english word"
      end
    else
      @outcome = "#{@guess} can't be build out of #{@grid}"
    end
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    @grid = Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(guess)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{guess}")
    json = JSON.parse(response.read)
    json['found']
  end
end
