class Public::RoomAccessesController < ApplicationController

  def create
    @room = Room.find(room_access_params[:room_id])
    #既存のstudy_themeを選択した際の処理
    room_access = current_user.room_accesses.create!(
      room_access_params.merge(
        entry_time: Time.current,
        study_status: "waiting",
        is_active: true
      )
    )

    ActionCable.server.broadcast "room_channel_#{@room.id}", {
      type: "active_users_list",
      active_users_list_html: render_to_string(
        partial: "shared/active_users_list",
        locals: { room_accesses: @room.room_accesses.where(is_active: true)}
      )
    }
    
    #roomにリダイレクト
    redirect_to public_room_path(room_access.room_id)
  end

  #def update
  #end

 #ストロングパラメータ
  private
  def room_access_params
    params.require(:room_access).permit(:room_id, :study_theme_id,)
  end

end
