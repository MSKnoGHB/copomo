class Public::RoomsController < ApplicationController
  def index
    @room = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end
end
