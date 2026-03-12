class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    #ユーザ情報を表示
    @all_records = @user.study_records.includes(:study_theme)
    @user_name = @user.name
    #最新４件の学習を表示_各情報を表示
    @recent_records = @user.study_records.order(ended_at: :desc).limit(4)
    #study_themesはis_active_TRUEのものだけ表示
    @study_themes = @user.study_themes.where(is_active: true)
    #テーマ別学習時間のグラフを表示
    @chart_records = @user.study_records.joins(:study_theme)
    @chart_data = @chart_records.group("study_themes.theme_title").sum(:total_focus_minutes)
    @chart_colors = @chart_records.group("study_themes.theme_title").order("study_themes.theme_title").pluck("study_themes.theme_color").map { |key| StudyTheme::COLOR_MAP[key]}
  end

  def edit
    @user = current_user

  end

  def update
    @user = current_user
    #ユーザ情報を更新
    @user.update!(user_params)
    redirect_to public_user_path(@user)
  end

  def destroy
    @user = current_user
    #ユーザ情報を物理削除
    @user.destroy!
    sign_out current_user
    redirect_to root_path
    #ユーザ情報を論理削除
    #@user.update!(is_active: false)
    #sign_out current_user
    #redirect_to public_root_path
    
  end


  private
  def user_params
    params.require(:user).permit(:name, :user_image)
  end


end
