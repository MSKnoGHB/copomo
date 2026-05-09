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
      #他ユーザへブロードキャスト
      public_html = render_to_string(
      partial: 'shared/chat_log',
      locals: { chat_log: @chat_log, is_admin: false }
      )
      admin_html = render_to_string(
      partial: 'shared/chat_log',
      locals: { chat_log: @chat_log, is_admin: true }
      )
      ActionCable.server.broadcast "room_channel_#{@chat_log.room_id}",{
        type: "chat_message",
        chat_log_html: public_html
      }
      ActionCable.server.broadcast "admin_room_channel_#{@chat_log.room_id}",{
          type: "chat_message",
          chat_log_html: admin_html
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