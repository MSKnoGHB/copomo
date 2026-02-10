class Public::StudyThemesController < ApplicationController
  def index
    @study_themes = StudyTheme.all
  end

  def create
    @study_theme = StudyTheme.new(study_theme_params)
    @study_theme.user_id = current_user.id
    @room = Room.find(params[:room_id])
    if @study_theme.save
      RoomAccess.create!(
        room_id: @room.id,
        user_id: current_user.id,
        study_theme_id: @study_theme.id,
        entry_time: Time.current,
        is_active: true,
        exit_type: 0,
      )
      redirect_to public_room_path(@room)
    else
      @study_access = RoomAccess.new 
      @study_themes = StudyTheme.all
      @study_categories = StudyCategory.all
      render "public/rooms/show"
    end
  end

  def edit
    @study_theme = StudyTheme.find(params[:id])
  end

  def update
  end

  private

  def study_theme_params
    params.require(:study_theme).permit(:study_category_id, :theme_title, :theme_body, :theme_color)
  end

  
end
