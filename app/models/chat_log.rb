class ChatLog < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :stamp, optional: true

  validates :message, presence: true, length: { maximum: 250}

  enum message_type: {stamp: 0, message: 1}


  after_create_commit { ActionCable.server.broadcast("room_channel_#{self.room_id}", { message: self.message, user_name: self.user.name }) }

end
