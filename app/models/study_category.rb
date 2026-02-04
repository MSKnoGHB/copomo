class StudyCategory < ApplicationRecord
  has_many :study_themes, dependent: :destroy

  validates :category_title, presence: true, uniqueness: true

end
