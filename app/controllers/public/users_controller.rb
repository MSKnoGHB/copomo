class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    #ユーザ情報を表示
    @user_name = @user.name
    #最新４件の学習を表示_各情報を表示
    @recent_records = current_user.study_records.order(ended_at: :desc).limit(4)
    #study_records一覧画面への遷移
 
  end

  def edit
    @user =User.find(params[:id])
  end

  def update
  end
end
     #<% @study_records.each do |study_record|%>
              #<p>日付：<%= study_record.ended_at.strftime("%-m月%-d日（%a）") %></p>
              #<p>学習テーマ：<%= study_record.study_theme.theme_title %></p>
              #<p>学習時間：<%= study_record.total_focus_minutes %>分</p>