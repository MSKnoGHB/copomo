class Public::RoomsController < ApplicationController
  def index
    @rooms = Room.all
    
  end

  def show
    @room = Room.find(params[:id])
    @study_record = StudyRecord.new
    @study_themes = StudyTheme.all
    @study_categories = StudyCategory.all
  end
end
