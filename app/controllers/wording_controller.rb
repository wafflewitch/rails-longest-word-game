require 'open-uri'
require 'json'

class WordingController < ApplicationController

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    return (0...grid_size).map { ('A'..'Z').to_a[rand(26)] }
  end

  def run_game(grid, start_time, attempt, end_time)
    # TODO: runs the game and return detailed hash of result
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=c8e9fee9-1322-47b5-b427-ba5907bc6df9&input=#{attempt}"
    result = { time: end_time - start_time, translation: nil, score: 0 }
    word_check = open(url).read
    attempt_trans = JSON.parse(word_check)["outputs"][0]["output"]
    attempt.upcase!
    in_grid = attempt.chars.all? do |letter|
      attempt.chars.count(letter) <= grid.count(letter)
    end
    if in_grid != true
      result[:message] = "not in the grid"
    elsif attempt_trans.upcase == attempt
      result[:message] = "not an english word"
    else
      result[:translation] = attempt_trans
      result[:score] = attempt.length * 1 / result[:time] * 1000.round
      result[:message] = "well done"
    end
    @score = result[:score].floor
    @message = result[:message]
  end

  def game
    @start_time = Time.now
    @grid = generate_grid(10).join(" ")
  end

  def score
    @grid = params[:grid]
    @start_time = params[:start_time].to_datetime
    @attempt = params[:attempt]
    @end_time = Time.now
    run_game(@grid, @start_time, @attempt, @end_time)
  end
end
