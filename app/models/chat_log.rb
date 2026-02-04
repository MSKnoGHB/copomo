class ChatLog < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :stamp
  validates :message, presence: true, length: { maximum: 250}
end
