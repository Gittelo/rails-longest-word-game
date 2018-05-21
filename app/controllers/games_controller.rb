require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    generate_grid(15)
  end

  def score
    @attempt = params[:attempt]
    @new_grid = params[:grid].split(" ")
    @result = run_game(@attempt, @new_grid)
  end

  private

  def generate_grid(grid_size)
  # TODO: generate random grid of letters
  # (0...grid_size).map { ('a'..'z').to_a[rand(26)] }.join.upcase
  letters = ('a'..'z').to_a
  @grid = []
  (1..grid_size).each { @grid << letters[rand(26)].to_s }
  @grid
  end
  def run_game(attempt, grid)
    attempt.downcase!
    array_attempt = attempt.split("")
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    serialized = open(url).read
    dictionary = JSON.parse(serialized)
    #raise

    if !array_attempt.all? { |letter| array_attempt.count(letter) <= grid.count(letter) }
      @result = "The word can't be built out of the original grid"
    elsif !dictionary["found"]
      @result = "The word is valid according to the grid, but is not a valid English word"
    else
      @result = "The word is valid according to the grid and is an English"
    end
    @result
  end
end
