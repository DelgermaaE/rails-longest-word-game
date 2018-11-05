require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
   @letters = []
   letter = ('A'..'Z').to_a
   10.times do
     @letters << letter.sample
   end
   @letters = @letters.join
  end

  def scores
    @input = params[:input]
    @letters = params[:letters].split('')

    #lewagon api to check if the word exist
    url = 'https://wagon-dictionary.herokuapp.com/'
    word_serialized = open(url + @input).read
    word = JSON.parse(word_serialized)
    bool = false

    word_tmp = word['word'].upcase.split('')
    word_tmp.each do |letter|
      bool = true if array_count(word_tmp, letter) > array_count(@letters, letter)
    end

    @result = word_ok?(bool, word)
  end

  #count letter
  def array_count(array, letter)
    array.reduce(0) { |t, n| t + number_count(n, letter) }
  end

  def number_count(number, letter)
    number.to_s.count(letter.to_s)
  end

  def word_ok?(bool, word)
    score = 0
    if word['found']
      message = "well done"
      score = word['length']
    elsif bool
      message = "not an english word"
    else
      message = "not in the grid"
    end
    return [score, message]
  end

end
