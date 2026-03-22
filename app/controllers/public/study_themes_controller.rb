class Public::StudyThemesController < ApplicationController
  before_action only: [:edit, :update, :destroy] do
    authorize_owner(StudyTheme.find(params[:id]))
  end

  def index
    @user = User.find(params[:user_id])
    @study_themes = @user.study_themes.where(is_active: true)
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
    @study_categories = StudyCategory.all
    
  end

  def update
    @study_theme = StudyTheme.find(params[:id])
    if @study_theme.update(study_theme_params)
      redirect_to public_user_study_themes_path(@study_theme.user)
    else
      @study_categories = StudyCategory.all
      render :edit
    end
  end

  def destroy
    @study_theme = StudyTheme.find(params[:id])
    @study_theme.update(is_active: false)
    redirect_to public_user_study_themes_path(@study_theme.user)
  end



  private

  def study_theme_params
    params.require(:study_theme).permit(:study_category_id, :theme_color, :theme_title, :theme_body)
  end

end
