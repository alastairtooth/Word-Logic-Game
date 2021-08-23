require 'json'
require 'open-uri'
require 'pry-byebug'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @attempt = params[:attempt]
    @attempt_array = @attempt.upcase.scan /\w/
    @letters = params[:letters].upcase.scan /\w/
    @user_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{@attempt}").read
    @user = JSON.parse(@user_serialized)
    @outcome = { score: 0 }
    if @attempt.upcase.chars.all? { |str| @letters.count(str.upcase) >= @attempt.upcase.chars.count(str) } == false
      @outcome[:message] = 'not in the grid'
    elsif @user['found'] == false
      @outcome[:message] = 'not an english word'
    else
      @outcome[:score] = 5
      @outcome[:message] = 'well done'
    end
  end
end
