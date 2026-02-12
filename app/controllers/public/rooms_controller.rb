class Public::RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
    @room_access = RoomAccess.new
    @study_theme = StudyTheme.new
    @study_themes = StudyTheme.all
    @study_categories = StudyCategory.all
    @select_study_theme = StudyTheme.find_by(params[:study_theme_id])

    active_access = current_user.room_accesses.find_by(is_active: true)
    @study_status = active_access&.study_status
    
    @study_record = current_user.study_records.find_by(ended_at: nil)
    if  @study_record
      @study_interval = @study_record.study_intervals.find_by( ended_at: nil)
    end
  end
end
