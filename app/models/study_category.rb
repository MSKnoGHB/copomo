class StudyCategory < ApplicationRecord
  has_many :study_themes, dependent: :destroy
end
