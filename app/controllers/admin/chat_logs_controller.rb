class Admin::ChatLogsController < ApplicationController
  layout "admin"

  def destroy
    chat_log = ChatLog.find(params[:id])
    room = chat_log.room
    chat_log.destroy
    redirect_to admin_room_path(room)
  end

end
