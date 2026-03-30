class Admin::RoomAccessesController < ApplicationController
  def force_exit
    room_access = RoomAccess.find(params[:id])
    target_user = room_access.user
    room = room_access.room
    room_accesses = room.room_accesses.where(is_active: true)    
    study_record = target_user.study_records.find_by(room_id: room.id, ended_at: nil)

    if study_record
      target_user.complete_study_session!(study_record.id, room_access.id, exit_type: 1)
      redirect_url = edit_public_study_record_path(study_record)
    else
      room_access.update!(is_active: false)
      redirect_url = public_rooms_path
    end

    public_html = render_to_string(
      partial: "shared/active_users_list",
      locals: {room_accesses: room_accesses, is_admin: false}
    )
    admin_html = render_to_string(
      partial: "shared/active_users_list",
      locals: {room_accesses: room_accesses, is_admin: true}
    )

    ActionCable.server.broadcast "room_channel_#{room.id}", {
      type: "active_users_list",
      active_users_list_html: public_html
    }
    ActionCable.server.broadcast "admin_room_channel_#{room.id}", {
        type: "active_users_list",
        active_users_list_html: admin_html
    }
 
    #対象ユーザーだけに「編集画面へ飛べ」という命令を送る
    ActionCable.server.broadcast "room_channel_#{room.id}", {
      type: "force_exit",
      target_user_id: target_user.id,
      redirect_url: redirect_url
    }
    # 管理者側の画面は、ボタンを押した後に何も返さない（またはJSで消す）
    head :no_content

  end
end