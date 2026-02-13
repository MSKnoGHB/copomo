class Public::RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])

    #modal_テーマ選択後の入室
    @room_access = RoomAccess.new
    @study_themes = StudyTheme.all

    #modal_テーマ新規作成後の入室
    @study_theme = StudyTheme.new
    @study_categories = StudyCategory.all
 
    
   
    
    
    @select_study_theme = StudyTheme.find_by(params[:study_theme_id])
    
    #room_accessを一意にする
    @active_room_access = current_user.room_accesses.find_by(is_active: true)
    #ボタン表示を制御するために現状の学習ステータスを格納する
    @study_status = @active_room_access&.study_status
    
    #study_recordを一意にする
    @study_record = current_user.study_records.find_by(ended_at: nil)
  end
end
