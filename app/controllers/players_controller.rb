class PlayersController < ApplicationController

  def index

  end

  def gamer
    @player = params[:gamertag]
  end
end
