class Public::RoomAccessesController < ApplicationController
  def create
    @room_access = RoomAccess.new
  end

  def update
  end
end
