class Stamp < ApplicationRecord
  has_one_attached :stamp_image
  has_many :chat_logs, dependent: :destroy
end
