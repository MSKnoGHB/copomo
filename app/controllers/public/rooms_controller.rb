class Public::RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])

    #modal 新規設定
    @new_study_theme = StudyTheme.new
    

    
    @new_room_access
    @study_themes = StudyTheme.all
    @study_categories = StudyCategory.all
    @select_study_theme = StudyTheme.find_by(params[:study_theme_id])
    
    #room_accessを一意にする
    @room_access = current_user.room_accesses.find_by(is_active: true)
    #ボタン表示を制御するために現状の学習ステータスを格納する
    @study_status = @room_access&.study_status
    
    #study_recordを一意にする
    @study_record = current_user.study_records.find_by(ended_at: nil)
  end
end
