class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    #ユーザ情報を表示
    @user_name = @user.name
    #最新４件の学習を表示_各情報を表示
    @recent_records = current_user.study_records.order(ended_at: :desc).limit(4)
    @study_themes = current_user.study_themes.all
 
  end

  def edit
    @user = User.find(params[:id])

  end

  def update
    @user = User.find(params[:id])
    #ユーザ情報を更新
    @user.update!(user_params)
    redirect_to public_user_path(@user)
  end

  private
  def user_params
    params.require(:user).permit(:name, :user_image)
  end


end
