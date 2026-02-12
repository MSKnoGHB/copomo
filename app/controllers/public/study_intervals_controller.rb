class Public::StudyIntervalsController < ApplicationController
  def index
    @study_intervals = StudyInterval.all
  end

  def create
    @study_record = current_user.study_records.find_by!(ended_at: nil)
    @room_access = current_user.room_accesses.find_by!(is_active: true)
    @room = Room.find(params[:room_id])

    @study_interval = StudyInterval.new(
      study_record_id: @study_record.id,
      started_at: Time.current
    )
    if @study_interval.save
      @room_access.update!(study_status: 1)
      redirect_to public_room_path(@room.id)
    end

  end

  def update
    @room = Room.find(params[:room_id])
    @study_interval = StudyInterval.find(params[:study_interval_id])
    @room_access = RoomAccess.find_by(
      user_id: current_user.id,
      is_active: true
    )
    if @study_interval.update(ended_at: Time.current)
      @room_access.update!(study_status: 3)
      redirect_to public_room_path(@room.id)
    end



  end

  def destroy
  end
end
