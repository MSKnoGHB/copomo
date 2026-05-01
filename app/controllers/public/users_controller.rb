class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  before_action :ensure_guest_user, only: [ :edit]

  def show
    @user = User.find(params[:id])
    #ユーザ情報を表示
    @all_records = @user.study_records.includes(:study_theme)
    @user_name = @user.name
    #最新４件の学習を表示_各情報を表示
    @recent_records = @user.study_records.order(ended_at: :desc).limit(4)
    #study_themesはis_active_TRUEのものだけ表示
    @study_themes = @user.study_themes.where(is_active: true)
    @display_study_themes = @study_themes.limit(6)
    @other_study_themes_count = @study_themes.count - @display_study_themes.count

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
    if @user.update(user_params)
      sleep(3)
      redirect_to public_user_path(@user), notice: 'ユーザ情報が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    #ユーザ情報を物理削除
    @user.destroy!
    sign_out current_user
    redirect_to new_user_registration_path, notice: '退会しました。'
    #ユーザ情報を論理削除
    #@user.update!(is_active: false)
    #sign_out current_user
    #redirect_to public_root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_image)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to public_user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end  

end
