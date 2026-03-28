class Admin::RoomAccessesController < ApplicationController
  def force_exit
    target_user = User.find(params[:user_id])
    study_record = target_user.complete_study_session!(
      params[:study_record_id], 
      params[:room_access_id],
      exit_type: 1
    )

    # 参加者リストの更新を通知
    broadcast_active_users_list(study_record.room)

    #対象ユーザーだけに「編集画面へ飛べ」という命令を送る
    ActionCable.server.broadcast "room_channel_#{study_record.room_id}", {
      type: "force_exit",
      target_user_id: target_user.id,
      redirect_url: edit_public_study_record_path(study_record.id)
    }
    # 管理者側の画面は、ボタンを押した後に何も返さない（またはJSで消す）
    head :no_content
  end

  private

  def broadcast_active_users_list(room)
    ActionCable.server.broadcast "room_channel_#{room.id}", {
      type: "active_users_list",
      active_users_list_html: render_to_string(
        partial: "shared/active_users_list",
        locals: { room_accesses: @room.room_accesses.where(is_active: true)}
      )
    }
  end
end