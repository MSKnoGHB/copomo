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

  def broadcast_active_users
    room_accesses = self.room_accesses.where(is_active: true)

    renderer = ApplicationController.renderer

    public_html = renderer.render(
      partial: "shared/active_users_list",
      locals:{room_accesses: room_accesses, is_admin: false}
    )
    admin_html = renderer.render(
      partial: "shared/active_users_list",
      locals:{room_accesses: room_accesses, is_admin: true}
    )

    ActionCable.server.broadcast "room_channel_#{self.id}", {
      type: "active_users_list", 
      active_users_list_html: public_html
    }
    ActionCable.server.broadcast "admin_room_channel_#{self.id}", {
      type: "active_users_list", 
      active_users_list_html: admin_html
    }
  end

end
