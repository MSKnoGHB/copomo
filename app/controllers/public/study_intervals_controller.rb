class Public::StudyIntervalsController < ApplicationController
  def index
    @study_intervals = StudyInterval.all
  end

  def create
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
    else
      

    end



  end

  def destroy
  end
end
