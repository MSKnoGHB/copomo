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

  def edit
  end

  def update
    #学習中に終了ボタンを押した際のstudy_intervalの更新
    study_record = current_user.study_records.find(params[:study_record_id])
    if study_record.study_intervals.exist?(ended_at: nil)
      study_interval = study_record.study_intervals.find_by(ended_at: nil)
      study_interval.update!(ended_at: Time.current)
    end
    
    #study_intervalの学習時間の合計処理
    study_intervals = study_record.study_intervals
    total = 0
    study_intervals.each do |interval|
     total += interval.ended_at - interval.started_at
    end

    #study_recordの更新
    study_record.update!(
      ended_at: Time.current,
      total_focus_minutes: total
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
    redirect_to edit_study_record_path(@study_record)

  end

  def destroy
  end

  private


end
