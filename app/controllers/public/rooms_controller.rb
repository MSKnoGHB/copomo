class Public::RoomsController < ApplicationController
  def index
    #学習ルーム選択
    @rooms = Room.all
  end

  def show
    #room_idの受け渡し
    @room = Room.find(params[:id])

    #modal_テーマ選択後の入室
    @room_access = RoomAccess.new
    @study_themes = StudyTheme.all

    #modal_テーマ新規作成後の入室
    @study_theme = StudyTheme.new
    @study_categories = StudyCategory.all
 
    #room_accessを一意にする
    @active_room_access = current_user.room_accesses.find_by(is_active: true)
    #ボタン表示を制御するために現状の学習ステータスを格納する
    @study_status = @active_room_access&.study_status
    #study_recordを一意にする
    @study_record = current_user.study_records.find_by(ended_at: nil)

    #現在参加者を表示
    @room_accesses = RoomAccess.where(is_active: true)

    @timer = @room.timer_status

    if  @study_record.present?
      interval = @study_record.study_intervals.find_by(ended_at: nil)
    end

    if @timer[:mode] == "集中" && @study_status == "studying" && interval.nil?
      @study_record.study_intervals.create!(
        started_at: Time.current
      )
    end

    if @timer[:mode] == "休憩" && @study_status == "studying" && interval.present?
      @study_record.study_intervals.update!(
        ended_at: Time.current
      )
    end

    Rails.logger.debug "mode: #{@timer[:mode]}"
    Rails.logger.debug "status: #{@study_status}"
    Rails.logger.debug "interval_nil: #{interval.nil?}"
  end
end
