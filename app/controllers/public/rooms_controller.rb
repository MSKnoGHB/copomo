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
    #@study_interval = StudyInterval.find_by(user_id: current_user.id, is_active: true)
    @study_record = StudyRecord.find_by(user_id: current_user.id, ended_at: nil )
    if @study_record
      @study_interval = @study_record.study_intervals.find_by(ended_at: nil)
    else
      @study_interval = nil
    end
  end
end
