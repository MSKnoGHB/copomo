class Room < ApplicationRecord
  has_many :room_accesses, dependent: :destroy
  has_many :chat_logs, dependent: :destroy
  has_many :study_records, dependent: :destroy
end
