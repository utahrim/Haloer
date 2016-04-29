class PlayersController < ApplicationController

  def index

  end

  def gamer
    @player = params[:gamertag]
    @count = params[:count]
  end
end
