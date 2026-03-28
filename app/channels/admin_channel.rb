class AdminChannel < ApplicationCable::Channel
  def subscribed
    stream_from "admin_global_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
