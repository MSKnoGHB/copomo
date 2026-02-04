class Like < ApplicationRecord
  belongs_to :user
  belongs_to :study_record

  validatable :user_id, uniqueness: { scope: :study_record_id}
end
