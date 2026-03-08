class Public::ChatLogsController < ApplicationController
  def create
    @room = Room.find(params[:chat_log][:room_id])
    @chat_log = current_user.chat_logs.new(chat_log_params)
    @chat_log.user_id = current_user.id
    @chat_log.message_type = :message
    
    if @chat_log.save
      ActionCable.server.broadcast "room_channel_#{@chat_log.room_id}", {
        message: @chatlog.message,
        user_name: current_user.name,
        image: view_context.image_tag(current_user.user_image, style: "width:30px; height:30px; object-fit:cover;")
      }
      head :ok
    else
      head :bad_request
    end
  end

  def chat_log_params
    params.require(:chat_log).permit(:message, :room_id)
  end
end