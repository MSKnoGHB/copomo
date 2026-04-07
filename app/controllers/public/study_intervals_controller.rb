class Public::StudyIntervalsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:auto_paused]

  def index
    @study_intervals = StudyInterval.all
  end

  def create #学習再開処理
    #study_intervalのレコードを作成
    study_record = current_user.study_records.find(params[:study_record_id])
    room = study_record.room

    if study_record.room.timer_status[:mode] == "集中"
      study_interval = study_record.study_intervals.create!(started_at: Time.current)
      Rails.logger.info "作成されたデータ: #{study_interval}"
    end
    
    #room_accessの学習ステータスの更新
    room_access = current_user.room_accesses.find(params[:room_access_id])
    room_access.update!(study_status: "studying")
    Rails.logger.info "room_access changes: #{room_access.saved_changes}"
    #roomにリダイレクト

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
    #redirect_to public_room_path(study_record.room_id)
    @active_room_access = room_access
    @study_record = study_record
    @study_status = @active_room_access.study_status
    @interval = study_interval
    @timer = room.timer_status
    respond_to do |format|
      format.js { render 'shared/study_control' }
    end
  end

  def update #一時停止処理
    #study_intervalのレコードを更新
    study_record = current_user.study_records.find(params[:study_record_id])
    study_interval = study_record.study_intervals.find_by(ended_at: nil)
    room = study_record.room
    if study_record.room.timer_status[:mode] == "集中"
      study_interval.update!(ended_at: Time.current)
      Rails.logger.info "study_interval changes: #{study_interval.saved_changes}"
    end
    #room_accessのレコードを更新
    room_access = current_user.room_accesses.find(params[:room_access_id])
    room_access.update!(study_status: "paused")
    Rails.logger.info "room_access changes: #{room_access.saved_changes}"

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
    #redirect_to public_room_path(study_record.room_id)
    @active_room_access = room_access
    @study_record = study_record
    @study_status = @active_room_access.study_status
    @interval = study_interval
    @timer = room.timer_status
    respond_to do |format|
      format.js { render 'shared/study_control' }
    end
  end

  def auto_pause 
    study_record = current_user.study_records.find_by(ended_at: nil)
    study_interval = study_record.study_intervals.find_by(ended_at: nil)
    room_access = current_user.room_accesses.find_by(is_active: true)
    room = room_access.room

    return unless study_interval

    if study_interval
      study_interval.update!(ended_at: Time.current)
      Rails.logger.info "study_interval changes: #{study_interval.saved_changes}"

      room_access.update!(study_status: "paused")
      Rails.logger.info "room_access changes: #{room_access.saved_changes}"
    end
    
    @active_room_access = room_access
    @study_record = study_record
    @study_status = @active_room_access.study_status
    @interval = study_interval
    @timer = room.timer_status

    respond_to do |format|
      format.js { render 'shared/study_control' }
    end
  end

end
