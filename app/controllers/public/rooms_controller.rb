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
    @study_themes = current_user.study_themes

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

    #タイマーを表示
    @timer = @room.timer_status

    #study_intervalを一意にする
    if  @study_record.present?
      interval = @study_record.study_intervals.find_by(ended_at: nil)
    end

    #集中モードへの切り替わり時にstudy_intervalのレコードを作成
    if @timer[:mode] == "集中" && @study_status == "studying" && interval.nil?
      @study_record.study_intervals.create!(
        started_at: Time.current
      )
    end
    #休憩モードへの切り替わり時にstudy_intervalのレコードを更新
    if @timer[:mode] == "休憩" && @study_status == "studying" && interval.present?
       interval.update!(
        ended_at: Time.current
      )
    end
    
    @chat_logs = @room.chat_logs.includes(:user).last(100)
    @chat_log = ChatLog.new
    @stamps = Stamp.all
  end
end
