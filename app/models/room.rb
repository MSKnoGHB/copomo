class Room < ApplicationRecord
  has_many :room_accesses, dependent: :destroy
  has_many :chat_logs, dependent: :destroy
  has_many :study_records, dependent: :destroy

  def timer_status
    cycle_seconds = (focus_minutes + break_minutes) * 60
    elapsed_seconds = Time.current - cycle_started_at
    position = elapsed_seconds % cycle_seconds
    focus_seconds = focus_minutes * 60
    if position < focus_seconds
      mode = "集中"
      remaining = focus_seconds - position
    else
      mode = "休憩"
      remaining = cycle_seconds - position
    end
    { mode: mode, remaining: remaining.to_i }
  end


end
