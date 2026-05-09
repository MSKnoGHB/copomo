class Public::RoomAccessesController < ApplicationController

  def create
    #既存のstudy_themeを選択した際の処理
    room_access = current_user.room_accesses.create!(
      room_access_params.merge(
        entry_time: Time.current,
        study_status: "waiting",
        is_active: true
      )
    )
    Rails.logger.info "作成されたデータ: #{room_access}"

    #RoomModel内のメソッドでブロードキャスト
    @room = Room.find(room_access_params[:room_id])
    @room.broadcast_active_users
    
    #roomにリダイレクト
    redirect_to public_room_path(room_access.room_id)
  end

  def status_change
    room_access = current_user.room_accesses.find(params[:room_access_id])
    study_status = room_access.study_status

    if room_access.studying?
      room_access.update!(study_status: "paused")
      Rails.logger.info "room_access changes: #{room_access.saved_changes}"
    else
      room_access.update!(study_status: "studying")
      Rails.logger.info "room_access changes: #{room_access.saved_changes}"
    end

    #RoomModel内のメソッドでブロードキャスト
    room = room_access.room
    room.broadcast_active_users

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