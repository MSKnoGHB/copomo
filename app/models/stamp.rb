class Stamp < ApplicationRecord
  has_many :chat_logs, dependent: :destroy

  has_one_attached :stamp_image

  validates :stamp_name, presence: true, uniqueness: true, length: { maximum: 10 }
end
