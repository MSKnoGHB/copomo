class ChatLog < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :stamp
end
