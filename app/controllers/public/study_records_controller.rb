class Public::StudyRecordsController < ApplicationController
  def index
    @study_records = StudyRecord.all
  end

  def show
    @study_record = StudyRecord.find(params[:id])
  end

  def create
    room_access = current_user.room_accesses.find(params[:room_access_id])
    #study_recordのレコードを作成
    study_record = current_user.study_records.create!(
      room_id: room_access.room_id,
      study_theme_id: room_access.study_theme.id,
      started_at: Time.current
    )

    #study_intervalのレコードを作成
    study_interval = study_record.study_intervals.create!(
      started_at: Time.current
    )
    
    #room_accessの学習ステータスを更新
    room_access.update!(study_status: "studying")
    redirect_to public_room_path(room_access.room_id)
  end


  def finish
    #学習中に終了ボタンを押した際のstudy_intervalの更新
    study_record = current_user.study_records.find(params[:study_record_id])
    if study_record.study_intervals.exists?(ended_at: nil)
      study_interval = study_record.study_intervals.find_by(ended_at: nil)
      study_interval.update!(ended_at: Time.current)
    end
    
    #study_intervalの学習時間の合計処理
    study_intervals = study_record.study_intervals
    total_seconds = 0
    total_minutes = 0
    study_intervals.each do |interval|
      total_seconds += interval.ended_at - interval.started_at
    end
    total_minutes += (total_seconds / 60)

    #study_recordの更新
    study_record.update!(
      ended_at: Time.current,
      total_focus_minutes: total_minutes
      ) 
    
    #room_accessの更新
    room_access = current_user.room_accesses.find(params[:room_access_id])
    room_access.update!(
      exit_time: Time.current,
      study_status: "finished",
      is_active: false,
      exit_type: 0
      )

    #画面遷移_学習記録投稿画面へ
    redirect_to edit_public_study_record_path(study_record.id)

  end

  def edit
    #学習結果を表示
    @study_record = StudyRecord.find(params[:id])
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
    @study_record.update!(study_record_params)
    redirect_to public_study_record_path(@study_record.id)

  end


  def destroy
  end

  private
  def study_record_params
    params.require(:study_record).permit(:record_body)
  end


end
