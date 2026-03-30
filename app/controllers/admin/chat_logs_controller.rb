class Admin::ChatLogsController < ApplicationController
  layout "admin"

  def destroy
    chat_log = ChatLog.find(params[:id])
    room_id = chat_log.room.id
    chat_log.destroy

    ActionCable.server.broadcast "room_channel_#{room_id}", {
      type: "delete_chat",
      chat_log_id: chat_log.id
    }
    head :no_content
  end

end
