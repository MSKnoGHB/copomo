class Public::StudyIntervalsController < ApplicationController

  def index
    @study_intervals = StudyInterval.all
  end

  def create #学習再開処理
    #study_intervalのレコードを作成
    study_record = current_user.study_records.find(params[:study_record_id])
    room = study_record.room
    if study_record.room.timer_status[:mode] == "集中"
      study_interval = study_record.study_intervals.create!(started_at: Time.current)
    end
    #room_accessの学習ステータスの更新
    room_access = current_user.room_accesses.find(params[:room_access_id])
    room_access.update!(study_status: "studying")
    #roomにリダイレクト

    ActionCable.server.broadcast "room_channel_#{room.id}", {
      type: "active_users_list", 
      active_users_list_html: render_to_string(
        partial: "shared/active_users_list",
        locals: { room_accesses: room.room_accesses.where(is_active: true)}
      )
    }

    redirect_to public_room_path(study_record.room_id)
  end

  def update #一時停止処理
    #study_intervalのレコードを更新
    study_record = current_user.study_records.find(params[:study_record_id])
    study_interval = study_record.study_intervals.find_by(ended_at: nil)
    room = study_record.room
    if study_record.room.timer_status[:mode] == "集中"
      study_interval.update!(ended_at: Time.current)
    end
    #room_accessのレコードを更新
    room_access = current_user.room_accesses.find(params[:room_access_id])
    room_access.update!(study_status: "paused")

    ActionCable.server.broadcast "room_channel_#{room.id}", {
      type: "active_users_list", 
      active_users_list_html: render_to_string(
        partial: "shared/active_users_list",
        locals: { room_accesses: room.room_accesses.where(is_active: true)}
      )
    }

    #roomにリダイレクト
    redirect_to public_room_path(study_record.room_id)
   
  end

  #def destroy 
  #end

end
