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
    
    #RoomModel内のメソッドでブロードキャスト
    room.broadcast_active_users
 
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