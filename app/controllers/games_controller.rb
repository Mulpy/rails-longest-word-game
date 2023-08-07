class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
  @start = Time.now()
  @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @time = params[:time]
    @score = 0
    if self.included
      if self.found
        @result = "Congratulations! '#{params[:word].upcase}' is a valid English word!"
        @score = (@word.size * 10) / (@time.to_f * 1000)
      else
        @result = "Sorry, but '#{params[:word].upcase}' does not appear to be a valid English word!"
      end
    else
      @result = "Sorry but '#{params[:word].upcase}' can't be built out of #{params[:letters].split.join(', ')}"
    end
  end

  def included
    @word = params[:word].upcase.chars
    @letters = params[:letters].split(' ')
    @word.all? { |letter| @word.count(letter) <= @letters.count(letter) }
  end

  def found
    @url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    @response = URI.parse(@url)
    @json = JSON.parse(@response.read)
    @json['found']
  end
end
