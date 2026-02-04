class StudyTheme < ApplicationRecord
  has_many :room_accesses
  has_many :study_records
  belongs_to :user
  belongs_to :study_category
end
