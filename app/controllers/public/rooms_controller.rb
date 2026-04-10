class Public::RoomsController < ApplicationController

  def index
    #学習ルーム選択
    @rooms = Room.all
    @active_room_access = current_user.room_accesses.find_by(is_active: true)
  end

  def show
    #room_idの受け渡し
    @room = Room.find(params[:id])

    #room_accessを一意にする
    @active_room_access = current_user.room_accesses.find_by(is_active: true)

    #URL直接入力によるアクセスを制限
    if @active_room_access && @active_room_access.room_id != @room.id
      flash[:alert] = "別のルームに入室中です。先に現在のルームを退室してください。"
      redirect_to public_rooms_path, alert: "別のルームに入室中です。先に現在のルームを退室してください。"
      return
    end

    #modal_テーマ選択後の入室
    @room_access = RoomAccess.new
    @study_themes = current_user.study_themes.where(is_active: true)

    #modal_テーマ新規作成後の入室
    @study_theme = StudyTheme.new
    @study_categories = StudyCategory.where(is_active: true)
 
    #ボタン表示を制御するために現状の学習ステータスを格納する
    @study_status = @active_room_access&.study_status
    #study_recordを一意にする
    @study_record = current_user.study_records.find_by(ended_at: nil)

    #現在参加者を表示
    @room_accesses = @room.room_accesses.where(is_active: true)

    #タイマーを表示
    @timer = @room.timer_status

    #study_intervalを一意にする
    if  @study_record.present?
      @interval = @study_record.study_intervals.find_by(ended_at: nil)
    end

    #集中モードへの切り替わり時にstudy_intervalのレコードを作成
    if @timer[:mode] == "集中" && @study_status == "studying" && @interval.nil?
      @interval = @study_record.study_intervals.create!(
        started_at: Time.current
      )
      Rails.logger.info "作成されたデータ: #{@interval}"
    end
    #休憩モードへの切り替わり時にstudy_intervalのレコードを更新
    if @timer[:mode] == "休憩" && @study_status == "studying" && @interval.present?
      @interval.update!(
        ended_at: Time.current
      )
      Rails.logger.info "study_interval changes: #{@interval.saved_changes}"
    end

    @chat_logs = @room.chat_logs.includes(:user).last(100)
    @chat_log = ChatLog.new
    @stamps = Stamp.where(is_active: true)
  end
end
