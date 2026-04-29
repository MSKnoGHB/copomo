class ChatLog < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :stamp, optional: true

  MESSAGE_MAX_LENGTH = 250 
  validates :message, presence: true, length: { maximum: MESSAGE_MAX_LENGTH }, unless: :stamp_id?

  enum message_type: {stamp: 0, message: 1}

  after_create_commit { ActionCable.server.broadcast("room_channel_#{self.room_id}", { message: self.message, user_name: self.user.name }) }

end
