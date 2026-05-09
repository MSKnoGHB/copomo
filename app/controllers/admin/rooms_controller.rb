class Admin::RoomsController < ApplicationController

  layout "admin"
  before_action :authenticate_admin!

  def index
    #学習ルーム選択
    @rooms = Room.all
    @room1_users = RoomAccess.where(room_id: 1, is_active: true)
    @room2_users = RoomAccess.where(room_id: 2, is_active: true)
    @room3_users = RoomAccess.where(room_id: 3, is_active: true)
  end

  def show
    #room_idの受け渡し
    @room = Room.find(params[:id])
    @room_accesses = @room.room_accesses.where(is_active: true)
    @timer = @room.timer_status
    @chat_logs = @room.chat_logs.includes(:user).last(100)
    @chat_log = ChatLog.new
    @stamps = Stamp.all
  end
  
end