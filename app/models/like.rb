class Like < ApplicationRecord
  belongs_to :user
  belongs_to :study_record

  validates :user_id, uniqueness: { scope: :study_record_id }
end
