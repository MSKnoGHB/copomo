class Public::ChatLogsController < ApplicationController
  def create
    @chat_log = ChatLog.new(chat_log_params)
    @chat_log.user_id = current_user.id
    if @chat_log.stamp_id.present?
      @chat_log.message_type = :stamp
    else
      @chat_log.message_type = :message
    end
    if @chat_log.save
      ActionCable.server.broadcast "room_channel_#{@chat_log.room_id}",{
      chat_log_html: render_to_string(partial: 'public/rooms/chat_log', locals: { chat_log: @chat_log })
    }
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def chat_log_params
    params.require(:chat_log).permit(:message, :room_id, :stamp_id)
  end
end