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
    #roomにリダイレクト
    redirect_to public_room_path(room_access.room_id)
  end

  def update
  end

 #ストロングパラメータ
  private
  def room_access_params
    params.require(:room_access).permit(:room_id, :study_theme_id,)
  end

end
