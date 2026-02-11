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
  end
end
