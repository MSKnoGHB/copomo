class Public::StudyThemesController < ApplicationController
  def index
    @study_themes = StudyTheme.all
  end

  def create
    #study_themeのレコードを作成
    study_theme = current_user.study_themes.create!(study_theme_params)
    #room_accessのレコードを作成
    room_access = current_user.room_accesses.create!(
      room_id: params[:study_theme][:room_id],
      study_theme_id: study_theme.id,
      entry_time: Time.current,
      study_status: "waiting",
      is_active: true
    )
    #roomにリダイレクト
    redirect_to public_room_path(room_access.room_id)
  end

  def edit
    @study_theme = StudyTheme.find(params[:id])
  end

  def update
  end

  private

  def study_theme_params
    params.require(:study_theme).permit(:study_category_id, :theme_color, :theme_title, :theme_body)
  end

  
end
