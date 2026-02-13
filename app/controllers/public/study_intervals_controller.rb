class Public::StudyIntervalsController < ApplicationController
  def index
    @study_intervals = StudyInterval.all
  end

  def create #学習再開処理
    #study_intervalのレコードを作成
    study_record = current_user.study_records.find(params[:study_record_id])
    study_interval = study_record.study_intervals.create!(started_at: Time.current)
    
    #room_accessの学習ステータスの更新
    room_access = current_user.room_accesses.find(params[:room_access_id])
    room_access.update!(study_status: "studying")

    #roomにリダイレクト
    redirect_to public_room_path(study_record.room_id)
   

  end

  def update #一時停止処理
    #study_intervalのレコードを更新
    study_record = current_user.study_records.find(params[:study_record_id])
    study_interval = study_record.study_intervals.find_by(ended_at: nil)
    study_interval.update!(ended_at: Time.current)

    #room_accessのレコードを更新
    room_access = current_user.room_accesses.find(params[:room_access_id])
    room_access.update!(study_status: "paused")

    #roomにリダイレクト
    redirect_to public_room_path(study_record.room_id)
   
  end

  def destroy 
  end
end
