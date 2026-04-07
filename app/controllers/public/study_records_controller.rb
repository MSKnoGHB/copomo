class Public::StudyRecordsController < ApplicationController
  before_action only: [:edit, :destroy] do
    authorize_owner(StudyRecord.find(params[:id]))
  end

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @study_records = @user.study_records.order(created_at: :desc)
    else
      @study_records = StudyRecord.order(created_at: :desc)
      @users = User.all 
      render :timeline
    end
  end

  def show
    #学習記録詳細表示
    @study_record = StudyRecord.find(params[:id])
    @room = @study_record.room.room_name
    @study_category = @study_record.study_theme.study_category.category_title
    @study_theme = @study_record.study_theme.theme_title
    @started_at = @study_record.started_at.strftime("%Y/%m/%d %H:%M:%S")
    @ended_at = @study_record.ended_at.strftime("%Y/%m/%d %H:%M:%S")
    @total_focus_minutes = @study_record.total_focus_minutes
    @record_body = @study_record.record_body
    @study_intervals = @study_record.study_intervals
    @comments = @study_record.comments.all
    @comment = @study_record.comments.new
  end

  def create
    room_access = current_user.room_accesses.find(params[:room_access_id])
    room = room_access.room

    #study_recordのレコードを作成
      study_record = current_user.study_records.create!(
        room_id: room_access.room_id,
        study_theme_id: room_access.study_theme.id,
        started_at: Time.current
      )
      Rails.logger.debug "作成されたデータ: #{study_record}"

    #study_intervalのレコードを作成
    if study_record.room.timer_status[:mode] == "集中"
      study_interval = study_record.study_intervals.create!(
        started_at: Time.current
      )
      Rails.logger.debug "作成されたデータ: #{study_interval}"
    end
    
    #room_accessの学習ステータスを更新
    room_access.update!(study_status: "studying")
    Rails.logger.debug "room_access changes: #{room_access.saved_changes}"

    #Actioncableによるリアルタイム表示
    room_accesses = room.room_accesses.where(is_active: true)

    public_html = render_to_string(
      partial: "shared/active_users_list",
      locals:{room_accesses: room_accesses, is_admin: false}
    )
    admin_html = render_to_string(
      partial: "shared/active_users_list",
      locals:{room_accesses: room_accesses, is_admin: true}
    )

    ActionCable.server.broadcast "room_channel_#{room.id}", {
      type: "active_users_list", 
      active_users_list_html: public_html
    }
    ActionCable.server.broadcast "admin_room_channel_#{room.id}", {
      type: "active_users_list", 
      active_users_list_html: admin_html
    }
    #head :ok 
    #redirect_to public_room_path(room_access.room_id)
    @active_room_access = room_access
    @study_record = study_record
    @study_status = @active_room_access.study_status
    @interval = study_interval
    @timer = room.timer_status
    respond_to do |format|
      format.js { render 'shared/study_control' }
    end
  end


  def finish
    target_record = current_user.study_records.find(params[:id])
    room = target_record.room
    #学習中に終了ボタンを押した際のstudy_intervalの更新
    #ADMIN共通メソッドとしてUSERモデルに処理を記載(compleate_study_session)
    study_record = current_user.complete_study_session!(
      params[:id],
      params[:room_access_id]
    )

    room_accesses = room.room_accesses.where(is_active: true)

    public_html = render_to_string(
      partial: "shared/active_users_list",
      locals:{room_accesses: room_accesses, is_admin: false}
    )
    admin_html = render_to_string(
      partial: "shared/active_users_list",
      locals:{room_accesses: room_accesses, is_admin: true}
    )

    ActionCable.server.broadcast "room_channel_#{room.id}", {
      type: "active_users_list", 
      active_users_list_html: public_html
    }
    ActionCable.server.broadcast "admin_room_channel_#{room.id}", {
      type: "active_users_list", 
      active_users_list_html: admin_html
    }
    #画面遷移_学習記録投稿画面へ
    redirect_to edit_public_study_record_path(study_record.id)
  end

  def edit
    #学習結果を表示
    @study_record = current_user.study_records.find(params[:id])
    @room = @study_record.room.room_name
    @study_category = @study_record.study_theme.study_category.category_title
    @study_theme = @study_record.study_theme.theme_title
    @started_at = @study_record.started_at.strftime("%Y/%m/%d %H:%M:%S")
    @ended_at = @study_record.ended_at.strftime("%Y/%m/%d %H:%M:%S")
    @total_focus_minutes = @study_record.total_focus_minutes
    #study_intervalを表示
    @study_intervals = @study_record.study_intervals
  end

  def post
    #学習後の記録
    @study_record = current_user.study_records.find(params[:id])

    if @study_record.update(study_record_params)
      Rails.logger.debug "study_record changes: #{@study_record.saved_changes}"
      redirect_to public_study_record_path(@study_record.id)
    else
      @room = @study_record.room.room_name
      @study_category = @study_record.study_theme.study_category.category_title
      @study_theme = @study_record.study_theme.theme_title
      @started_at = @study_record.started_at.strftime("%Y/%m/%d %H:%M:%S")
      @ended_at = @study_record.ended_at.strftime("%Y/%m/%d %H:%M:%S")
      @total_focus_minutes = @study_record.total_focus_minutes
      #study_intervalを表示
      @study_intervals = @study_record.study_intervals
      render :edit
    end
  end

  def destroy
    @study_record = current_user.study_records.find(params[:id])
    @study_record.destroy
    redirect_to public_user_study_records_path(@study_record.user)
  end

  private
  def study_record_params
    params.require(:study_record).permit(:record_body, :is_publish)
  end


end
