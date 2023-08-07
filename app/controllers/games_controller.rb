class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase.chars
    @letters = params[:letters].split(' ')
    @included = @word.all? { |letter| @word.count(letter) <= @letters.count(letter) }
    @url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    @response = URI.parse(@url)
    @json = JSON.parse(@response.read)
    @found = @json["found"]
    @score = 0
    if @included
      if @found
        @result = "Congratulations! #{params[:word].upcase} is a valid English word!"
        @score = @word.size
      else
        @result = "Sorry, but #{params[:word].upcase} does not appear to be a valid English word!"
      end
    else
      @result = "Sorry but #{params[:word].upcase} can't be built out of #{params[:letters].split.join(', ')}"
    end
  end
end
