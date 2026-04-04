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

    room_accesses = @room.room_accesses.where(is_active: true)

    public_html = render_to_string(
      partial: "shared/active_users_list",
      locals: {room_accesses: room_accesses, is_admin: false}
    )
    admin_html = render_to_string(
      partial: "shared/active_users_list",
      locals: {room_accesses: room_accesses, is_admin: true}
    )

    ActionCable.server.broadcast "room_channel_#{@room.id}", {
      type: "active_users_list",
      active_users_list_html: public_html
    }
    ActionCable.server.broadcast "admin_room_channel_#{@room.id}", {
      type: "active_users_list",
      active_users_list_html: admin_html
    }
    
    #roomにリダイレクト
    redirect_to public_room_path(room_access.room_id)
  end

  def status_change
    
    room_access = current_user.room_accesses.find(params[:room_access_id])
    study_status = room_access.study_status

    if room_access.studying?
      room_access.update!(study_status: "paused")
    else
      room_access.update!(study_status: "studying")
    end

    room = room_access.room
    room_accesses = room.room_accesses.where(is_active: true)
    

    public_html = render_to_string(
      partial: "shared/active_users_list",
      locals:{room_accesses: room_accesses, is_admin: false}
    )
  

    admin_html = render_to_string(
      partial: "shared/active_users_list",
      locals:{room_accesses: room_accesses, is_admin: true}
    )

    ActionCable.server.broadcast "room_channel_#{room.id}", {
      type: "active_users_list", 
      active_users_list_html: public_html
    }
    ActionCable.server.broadcast "admin_room_channel_#{room.id}", {
      type: "active_users_list", 
      active_users_list_html: admin_html
    }
    @active_room_access = room_access
    @study_record = current_user.study_records.find(params[:study_record_id])
    @study_status = @active_room_access.study_status
    @timer = room.timer_status
    respond_to do |format|
      format.js { render 'shared/study_control' }
    end
  end

 #ストロングパラメータ
  private
  def room_access_params
    params.require(:room_access).permit(:room_id, :study_theme_id,)
  end

end