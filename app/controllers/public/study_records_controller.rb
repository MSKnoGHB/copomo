class Public::StudyRecordsController < ApplicationController
  def index
    @study_records = StudyRecord.all
  end

  def show
    @study_record = StudyRecord.find(params[:id])
  end

  def create
    @room = Room.find(params[:room_id])
    @study_theme = StudyTheme.find(params[:study_theme_id])
    @study_record = current_user.study_records.new(
      room_id: @room.id,
      study_theme_id: @study_theme.id,
      started_at: Time.current
    )
    if @study_record.save
      StudyInterval.create!(
        study_record_id: @study_record.id,
        started_at: Time.current
      )
      redirect_to public_room_path(@room), notice: "学習を開始しました"
    else
      render "public/rooms/show", alert: "学習を開始できませんでした"
    end
  end

  def edit
    @study_record = StudyRecord.find(params[:id])

  end

  def update
    @
  end

  def destroy
  end

  private


end
